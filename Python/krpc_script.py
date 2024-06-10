import krpc
import math
import time

# Connect to KSP
conn = krpc.connect(name='Tester')
space_center = conn.space_center

# Retrieve active vessel and telemetry streams
vessel = space_center.active_vessel
ut = conn.add_stream(getattr, conn.space_center, 'ut')
altitude = conn.add_stream(getattr, vessel.flight(), 'mean_altitude')
apoapsis = conn.add_stream(getattr, vessel.orbit, 'apoapsis_altitude')
stage_2_resources = vessel.resources_in_decouple_stage(stage=2, cumulative=False)
srb_fuel = conn.add_stream(stage_2_resources.amount, 'SolidFuel')

# Define target altitude and turn parameters
turn_start_altitude = 250
turn_end_altitude = 45000
target_altitude = 150000

# Pre-launch setup
vessel.control.sas = False
vessel.control.rcs = False
vessel.control.throttle = 1.0

# Activate next stage to start launch
vessel.control.activate_next_stage()

# Engage autopilot and set initial pitch and heading
vessel.auto_pilot.engage()
vessel.auto_pilot.target_pitch_and_heading(90, 90)

# Initialize variables for turn maneuver
srbs_separated = False
turn_angle = 0

# Main ascent loop
while True:
    # Perform gravity turn
    if altitude() > turn_start_altitude and altitude() < turn_end_altitude:
        frac = ((altitude() - turn_start_altitude) /
                (turn_end_altitude - turn_start_altitude))
        new_turn_angle = frac * 90
        if abs(new_turn_angle - turn_angle) > 0.5:
            turn_angle = new_turn_angle
            vessel.auto_pilot.target_pitch_and_heading(90 - turn_angle, 90)

    # Separate SRBs when fuel is depleted
    if not srbs_separated:
        if srb_fuel() < 0.1:
            vessel.control.activate_next_stage()
            srbs_separated = True
            print('\n\033[91mWarning: SRBs Separated\033[0m')

    # Break loop and cut throttle when approaching target altitude
    if apoapsis() > target_altitude * 0.9:
        print('\n\033[93mAlert: Approaching Target Altitude\033[0m')
        vessel.control.throttle = 0.0  # Cut throttle
        break

# Coast out of atmosphere
while altitude() > 62500:
    pass

print('\n\033[92mEvent: Coasting out of atmosphere\033[0m')

# Check altitude for final stage
if altitude() > 40000:
    # Stage one last time
    vessel.control.activate_next_stage()
    print('\n\033[91mWarning: Final stage activated\033[0m')

# Plan circularization burn
mu = vessel.orbit.body.gravitational_parameter
r = vessel.orbit.apoapsis
a1 = vessel.orbit.semi_major_axis
a2 = r
v1 = math.sqrt(mu * ((2. / r) - (1. / a1)))
v2 = math.sqrt(mu * ((2. / r) - (1. / a2)))

delta_v = v2 - v1
node = vessel.control.add_node(
    ut() + vessel.orbit.time_to_apoapsis, prograde=delta_v)

F = vessel.available_thrust
Isp = vessel.specific_impulse * 9.82
m0 = vessel.mass
m1 = m0 / math.exp(delta_v / Isp)
flow_rate = F / Isp
burn_time = (m0 - m1) / flow_rate

print('\n\033[92mEvent: Planning circular burn\033[0m')

# Orient ship for burn
vessel.auto_pilot.reference_frame = node.reference_frame
vessel.auto_pilot.target_direction = (0, 1, 0)
vessel.auto_pilot.wait()

# Calculate the exact time to start the burn
burn_ut = ut() + vessel.orbit.time_to_apoapsis - (burn_time / 2.)

# Warp to a few seconds before the burn
lead_time = 10  # Adjust as needed
conn.space_center.warp_to(burn_ut - lead_time)

# Wait until just before the burn
while ut() < burn_ut - 0.1:
    pass

print('\n\033[93mAlert: Ready to execute burn\033[0m')

# Execute burn
vessel.control.throttle = 1.0
time.sleep(burn_time)

# Shutdown engines
vessel.control.throttle = 0.0

# Remove maneuver node
node.remove()

print('\n\033[92mEvent: Launch Complete.\033[0m')