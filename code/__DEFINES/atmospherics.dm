//ATMOS
//stuff you should probably leave well alone!
#define R_IDEAL_GAS_EQUATION	8.31	//! kPa*L/(K*mol)
#define ONE_ATMOSPHERE			101.325	//! kPa
#define TCMB					2.7		//! -270.3degC
#define TCRYO					225		//! -48.15degC
#define T0C						273.15	//! 0degC
#define T20C					293.15	//! 20degC

#define MOLES_CELLSTANDARD		(ONE_ATMOSPHERE*CELL_VOLUME/(T20C*R_IDEAL_GAS_EQUATION))	//! moles in a 2.5 m^3 cell at 101.325 Pa and 20 degC
#define M_CELL_WITH_RATIO		(MOLES_CELLSTANDARD * 0.005) //! compared against for superconductivity
#define O2STANDARD				0.21	//! percentage of oxygen in a normal mixture of air
#define N2STANDARD				0.79	//! percentage of nitrogen in a normal mixture of air
#define MOLES_O2STANDARD		(MOLES_CELLSTANDARD*O2STANDARD)	//! O2 standard value (21%)
#define MOLES_N2STANDARD		(MOLES_CELLSTANDARD*N2STANDARD)	//! N2 standard value (79%)
#define CELL_VOLUME				2500	//! liters in a cell
#define BREATH_VOLUME			0.5		//! liters in a normal breath
#define BREATH_PERCENTAGE		(BREATH_VOLUME/CELL_VOLUME)					//! Amount of air to take a from a tile

//EXCITED GROUPS
#define EXCITED_GROUP_BREAKDOWN_CYCLES				3		//! number of FULL air controller ticks before an excited group breaks down (averages gas contents across turfs)
#define EXCITED_GROUP_DISMANTLE_CYCLES				15		//! number of FULL air controller ticks before an excited group dismantles and removes its turfs from active
#define MINIMUM_AIR_RATIO_TO_SUSPEND				0.1		//! Ratio of air that must move to/from a tile to reset group processing
#define MINIMUM_AIR_RATIO_TO_MOVE					0.05	//! Minimum ratio of air that must move to/from a tile
#define MINIMUM_AIR_TO_SUSPEND						(MOLES_CELLSTANDARD*MINIMUM_AIR_RATIO_TO_SUSPEND)	//! Minimum amount of air that has to move before a group processing can be suspended
#define MINIMUM_MOLES_DELTA_TO_MOVE					(MOLES_CELLSTANDARD*MINIMUM_AIR_RATIO_TO_MOVE) //! Either this must be active or MINIMUM_TEMPERATURE_TO_MOVE
#define MINIMUM_TEMPERATURE_TO_MOVE					(T20C+100)			//! Either this must be active or MINIMUM_MOLES_DELTA_TO_MOVE
#define MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND		4		//! Minimum temperature difference before group processing is suspended
#define MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER		1		//! Minimum temperature difference before the gas temperatures are just set to be equal
#define MINIMUM_TEMPERATURE_FOR_SUPERCONDUCTION		(T20C+10)
#define MINIMUM_TEMPERATURE_START_SUPERCONDUCTION	(T20C+200)

//HEAT TRANSFER COEFFICIENTS
//Must be between 0 and 1. Values closer to 1 equalize temperature faster
//Should not exceed 0.4 else strange heat flow occur
#define WALL_HEAT_TRANSFER_COEFFICIENT		0.0
#define OPEN_HEAT_TRANSFER_COEFFICIENT		0.4
#define WINDOW_HEAT_TRANSFER_COEFFICIENT	0.1		//a hack for now
#define HEAT_CAPACITY_VACUUM				7000	//a hack to help make vacuums "cold", sacrificing realism for gameplay

//FIRE
#define FIRE_MINIMUM_TEMPERATURE_TO_SPREAD	(150+T0C)
#define FIRE_MINIMUM_TEMPERATURE_TO_EXIST	(100+T0C)
#define FIRE_SPREAD_RADIOSITY_SCALE			0.85
#define FIRE_GROWTH_RATE					40000	//For small fires
///plasma
#define PLASMA_MINIMUM_BURN_TEMPERATURE		(100+T0C)
#define PLASMA_UPPER_TEMPERATURE			(1370+T0C)
#define PLASMA_OXYGEN_FULLBURN				10
///hydrogen
#define HYDROGEN_MINIMUM_BURN_TEMPERATURE	(100+T0C)
#define HYDROGEN_UPPER_TEMPERATURE			(1370+T0C)
#define HYDROGEN_OXYGEN_FULLBURN			10

//COLD FIRE (this is used only for the freon-o2 reaction, there is no fire still)
#define COLD_FIRE_MAXIMUM_TEMPERATURE_TO_SPREAD	263 //fire will spread if the temperature is -10 °C
#define COLD_FIRE_MAXIMUM_TEMPERATURE_TO_EXIST	273 //fire will start if the temperature is 0 °C
#define COLD_FIRE_SPREAD_RADIOSITY_SCALE		0.95
#define COLD_FIRE_GROWTH_RATE					40000
#define FREON_MAXIMUM_BURN_TEMPERATURE			293
#define FREON_LOWER_TEMPERATURE					30 //minimum temperature allowed for the burn to go, we would have negative pressure otherwise
#define FREON_OXYGEN_FULLBURN					10

//GASES
#define MIN_TOXIC_GAS_DAMAGE				1
#define MAX_TOXIC_GAS_DAMAGE				10
#define MOLES_GAS_VISIBLE					0.25 //! Moles in a standard cell after which gases are visible

#define FACTOR_GAS_VISIBLE_MAX				20 //! moles_visible * FACTOR_GAS_VISIBLE_MAX = Moles after which gas is at maximum visibility
#define MOLES_GAS_VISIBLE_STEP				0.25 //! Mole step for alpha updates. This means alpha can update at 0.25, 0.5, 0.75 and so on

//REACTIONS
//return values for reactions (bitflags)
#define NO_REACTION		0
#define REACTING		1
#define STOP_REACTIONS 	2

// Pressure limits.
/// This determins at what pressure the ultra-high pressure red icon is displayed. (This one is set as a constant)
#define HAZARD_HIGH_PRESSURE 550
/// This determins when the orange pressure icon is displayed (it is 0.7 * HAZARD_HIGH_PRESSURE)
#define WARNING_HIGH_PRESSURE 325
/// This is when the gray low pressure icon is displayed. (it is 2.5 * HAZARD_LOW_PRESSURE)
#define WARNING_LOW_PRESSURE 50
/// This is when the black ultra-low pressure icon is displayed. (This one is set as a constant)
#define HAZARD_LOW_PRESSURE 20


/// This is used in handle_temperature_damage() for humans, and in reagents that affect body temperature. Temperature damage is multiplied by this amount.
#define TEMPERATURE_DAMAGE_COEFFICIENT 1.5

/// The natural temperature for a body
#define BODYTEMP_NORMAL 310.15
/// This is the divisor which handles how much of the temperature difference between the current body temperature and 310.15K (optimal temperature) humans auto-regenerate each tick. The higher the number, the slower the recovery. This is applied each tick, so long as the mob is alive.
#define BODYTEMP_AUTORECOVERY_DIVISOR 28
/// Minimum amount of kelvin moved toward 310K per tick. So long as abs(310.15 - bodytemp) is more than 50.
#define BODYTEMP_AUTORECOVERY_MINIMUM 3
///Similar to the BODYTEMP_AUTORECOVERY_DIVISOR, but this is the divisor which is applied at the stage that follows autorecovery. This is the divisor which comes into play when the human's loc temperature is lower than their body temperature. Make it lower to lose bodytemp faster.
#define BODYTEMP_COLD_DIVISOR 15
/// Similar to the BODYTEMP_AUTORECOVERY_DIVISOR, but this is the divisor which is applied at the stage that follows autorecovery. This is the divisor which comes into play when the human's loc temperature is higher than their body temperature. Make it lower to gain bodytemp faster.
#define BODYTEMP_HEAT_DIVISOR 15
/// The maximum number of degrees that your body can cool in 1 tick, due to the environment, when in a cold area.
#define BODYTEMP_COOLING_MAX -30
/// The maximum number of degrees that your body can heat up in 1 tick, due to the environment, when in a hot area.
#define BODYTEMP_HEATING_MAX 30

/// The body temperature limit the human body can take before it starts taking damage from heat.
/// This also affects how fast the body normalises it's temperature when hot.
/// 340k is about 66c, and rather high for a human.
#define BODYTEMP_HEAT_DAMAGE_LIMIT (BODYTEMP_NORMAL + 30)
/// The body temperature limit the human body can take before it starts taking damage from cold.
/// This also affects how fast the body normalises it's temperature when cold.
/// 270k is about -3c, that is below freezing and would hurt over time.
#define BODYTEMP_COLD_DAMAGE_LIMIT (BODYTEMP_NORMAL - 40)
/// The body temperature limit the human body can take before it will take wound damage.
#define BODYTEMP_HEAT_WOUND_LIMIT (BODYTEMP_NORMAL + 90) // 400.5 k
/// The modifier on cold damage limit hulks get ontop of their regular limit
#define BODYTEMP_HULK_COLD_DAMAGE_LIMIT_MODIFIER 25
/// The modifier on cold damage hulks get.
#define HULK_COLD_DAMAGE_MOD 2

// Body temperature warning icons
/// The temperature the red icon is displayed.
#define BODYTEMP_HEAT_WARNING_3 (BODYTEMP_HEAT_DAMAGE_LIMIT + 360) //+700k
/// The temperature the orange icon is displayed.
#define BODYTEMP_HEAT_WARNING_2 (BODYTEMP_HEAT_DAMAGE_LIMIT + 120) //460K
/// The temperature the yellow icon is displayed.
#define BODYTEMP_HEAT_WARNING_1 (BODYTEMP_HEAT_DAMAGE_LIMIT) //340K
/// The temperature the light green icon is displayed.
#define BODYTEMP_COLD_WARNING_1 (BODYTEMP_COLD_DAMAGE_LIMIT) //270k
/// The temperature the cyan icon is displayed.
#define BODYTEMP_COLD_WARNING_2 (BODYTEMP_COLD_DAMAGE_LIMIT - 70) //200k
/// The temperature the blue icon is displayed.
#define BODYTEMP_COLD_WARNING_3 (BODYTEMP_COLD_DAMAGE_LIMIT - 150) //120k

/// The amount of pressure damage someone takes is equal to (pressure / HAZARD_HIGH_PRESSURE)*PRESSURE_DAMAGE_COEFFICIENT, with the maximum of MAX_PRESSURE_DAMAGE
#define PRESSURE_DAMAGE_COEFFICIENT 2
#define MAX_HIGH_PRESSURE_DAMAGE 2
/// The amount of damage someone takes when in a low pressure area (The pressure threshold is so low that it doesn't make sense to do any calculations, so it just applies this flat value).
#define LOW_PRESSURE_DAMAGE 2

/// Humans are slowed by the difference between bodytemp and BODYTEMP_COLD_DAMAGE_LIMIT divided by this
#define COLD_SLOWDOWN_FACTOR 20


//CLOTHES
/// what min_cold_protection_temperature is set to for space-helmet quality headwear. MUST NOT BE 0.
#define SPACE_HELM_MIN_TEMP_PROTECT 2.0
/// Thermal insulation works both ways /Malkevin
#define SPACE_HELM_MAX_TEMP_PROTECT 1500
/// what min_cold_protection_temperature is set to for space-suit quality jumpsuits or suits. MUST NOT BE 0.
#define SPACE_SUIT_MIN_TEMP_PROTECT 2.0
/// The min cold protection of a space suit without the heater active
#define SPACE_SUIT_MIN_TEMP_PROTECT_OFF 72
#define SPACE_SUIT_MAX_TEMP_PROTECT 1500

//Emergency skinsuits
//The helmet is pressurized with air from the oxygen tank. If they don't take damage from that they won't take damage here
#define EMERGENCY_HELM_MIN_TEMP_PROTECT 2.0
//This is the approximate average temperature of Mt. Everest in the winter
#define EMERGENCY_SUIT_MIN_TEMP_PROTECT 237

//Firesuits
/// Cold protection for firesuits
#define FIRE_SUIT_MIN_TEMP_PROTECT 60
/// what max_heat_protection_temperature is set to for firesuit quality suits. MUST NOT BE 0.
#define FIRE_SUIT_MAX_TEMP_PROTECT 30000
/// Cold protection for fire helmets
#define FIRE_HELM_MIN_TEMP_PROTECT 60
/// for fire helmet quality items (red and white hardhats)
#define FIRE_HELM_MAX_TEMP_PROTECT 30000

/// what max_heat_protection_temperature is set to for firesuit quality suits and helmets. MUST NOT BE 0.
#define FIRE_IMMUNITY_MAX_TEMP_PROTECT 35000

/// For normal helmets
#define HELMET_MIN_TEMP_PROTECT 160
/// For normal helmets
#define HELMET_MAX_TEMP_PROTECT 600
/// For armor
#define ARMOR_MIN_TEMP_PROTECT 160
/// For armor
#define ARMOR_MAX_TEMP_PROTECT 600

/// For some gloves (black and)
#define GLOVES_MIN_TEMP_PROTECT 2.0
/// For some gloves
#define GLOVES_MAX_TEMP_PROTECT 1500
/// For gloves
#define SHOES_MIN_TEMP_PROTECT 2.0
/// For gloves
#define SHOES_MAX_TEMP_PROTECT 1500


//PIPES
//Atmos pipe limits
/// (kPa) What pressure pumps and powered equipment max out at.
#define MAX_OUTPUT_PRESSURE					4500
/// (L/s) Maximum speed powered equipment can work at.
#define MAX_TRANSFER_RATE 200
/// How many percent of the contents that an overclocked volume pumps leak into the air
#define VOLUME_PUMP_LEAK_AMOUNT 0.1

//used for device_type vars
#define UNARY		1
#define BINARY 		2
#define TRINARY		3
#define QUATERNARY	4

//TANKS
#define TANK_MELT_TEMPERATURE				1000000	//! temperature in kelvins at which a tank will start to melt
#define TANK_LEAK_PRESSURE					(30.*ONE_ATMOSPHERE)	//! temperature in kelvins at which a tank starts leaking
#define TANK_RUPTURE_PRESSURE				(35.*ONE_ATMOSPHERE)	//! temperature in kelvins at which a tank spills all contents into atmosphere
#define TANK_FRAGMENT_PRESSURE				(40.*ONE_ATMOSPHERE)	//! temperature in kelvins at which a tank creates a boom 3x3 base explosion
#define TANK_FRAGMENT_SCALE	    			(6.*ONE_ATMOSPHERE)		//! +1 for each SCALE kPa aboe threshold
#define TANK_MAX_RELEASE_PRESSURE 			(ONE_ATMOSPHERE*3)
#define TANK_MIN_RELEASE_PRESSURE 			0
#define TANK_DEFAULT_RELEASE_PRESSURE 		17

//CANATMOSPASS
#define ATMOS_PASS_YES 1
#define ATMOS_PASS_NO 0
#define ATMOS_PASS_PROC -1 //ask CanAtmosPass()
#define ATMOS_PASS_DENSITY -2 //just check density

#define CANATMOSPASS(A, O) ( A.CanAtmosPass == ATMOS_PASS_PROC ? A.CanAtmosPass(O) : ( A.CanAtmosPass == ATMOS_PASS_DENSITY ? !A.density : A.CanAtmosPass ) )
#define CANVERTICALATMOSPASS(A, O) ( A.CanAtmosPassVertical == ATMOS_PASS_PROC ? A.CanAtmosPass(O, TRUE) : ( A.CanAtmosPassVertical == ATMOS_PASS_DENSITY ? !A.density : A.CanAtmosPassVertical ) )

//OPEN TURF ATMOS
#define OPENTURF_DEFAULT_ATMOS		"o2=22;n2=82;TEMP=293.15" //the default air mix that open turfs spawn
#define OPENTURF_LOW_PRESSURE		"o2=14;n2=30;TEMP=293.15"
#define TCOMMS_ATMOS				"n2=100;TEMP=80" //-193,15°C telecommunications. also used for xenobiology slime killrooms
#define AIRLESS_ATMOS				"TEMP=2.7" //space
#define FROZEN_ATMOS				"o2=22;n2=82;TEMP=180" //-93.15°C snow and ice turfs
#define BURNMIX_ATMOS				"o2=100;plasma=200;TEMP=370" //used in the holodeck burn test program

//ATMOSPHERICS DEPARTMENT GAS TANK TURFS
#define ATMOS_TANK_N2O				"n2o=6000;TEMP=293.15"
#define ATMOS_TANK_CO2				"co2=50000;TEMP=293.15"
#define ATMOS_TANK_PLASMA			"plasma=70000;TEMP=293.15"
#define ATMOS_TANK_O2				"o2=100000;TEMP=293.15"
#define ATMOS_TANK_N2				"n2=100000;TEMP=293.15"
#define ATMOS_TANK_AIRMIX			"o2=2644;n2=10580;TEMP=293.15"

//LAVALAND
#define LAVALAND_EQUIPMENT_EFFECT_PRESSURE 90 //! what pressure you have to be under to increase the effect of equipment meant for lavaland
#define LAVALAND_DEFAULT_ATMOS		"o2=14;n2=5;co2=13;TEMP=300"

//MONKEDOME
#define MONKEDOME_DEFAULT_ATMOS		"o2=14;n2=5;co2=13;TEMP=300" // Currently just lavaland mix until final mixture composition is decided

//ATMOS MIX IDS
//Lavaland used to live here. That was a mistake.

//ATMOSIA GAS MONITOR TAGS
#define ATMOS_GAS_MONITOR_INPUT_O2 "o2_in"
#define ATMOS_GAS_MONITOR_OUTPUT_O2 "o2_out"
#define ATMOS_GAS_MONITOR_SENSOR_O2 "o2_sensor"

#define ATMOS_GAS_MONITOR_INPUT_TOX "tox_in"
#define ATMOS_GAS_MONITOR_OUTPUT_TOX "tox_out"
#define ATMOS_GAS_MONITOR_SENSOR_TOX "tox_sensor"

#define ATMOS_GAS_MONITOR_INPUT_AIR "air_in"
#define ATMOS_GAS_MONITOR_OUTPUT_AIR "air_out"
#define ATMOS_GAS_MONITOR_SENSOR_AIR "air_sensor"

#define ATMOS_GAS_MONITOR_INPUT_MIX "mix_in"
#define ATMOS_GAS_MONITOR_OUTPUT_MIX "mix_out"
#define ATMOS_GAS_MONITOR_SENSOR_MIX "mix_sensor"

#define ATMOS_GAS_MONITOR_INPUT_N2O "n2o_in"
#define ATMOS_GAS_MONITOR_OUTPUT_N2O "n2o_out"
#define ATMOS_GAS_MONITOR_SENSOR_N2O "n2o_sensor"

#define ATMOS_GAS_MONITOR_INPUT_N2 "n2_in"
#define ATMOS_GAS_MONITOR_OUTPUT_N2 "n2_out"
#define ATMOS_GAS_MONITOR_SENSOR_N2 "n2_sensor"

#define ATMOS_GAS_MONITOR_INPUT_CO2 "co2_in"
#define ATMOS_GAS_MONITOR_OUTPUT_CO2 "co2_out"
#define ATMOS_GAS_MONITOR_SENSOR_CO2 "co2_sensor"

#define ATMOS_GAS_MONITOR_INPUT_INCINERATOR "incinerator_in"
#define ATMOS_GAS_MONITOR_OUTPUT_INCINERATOR "incinerator_out"
#define ATMOS_GAS_MONITOR_SENSOR_INCINERATOR "incinerator_sensor"

#define ATMOS_GAS_MONITOR_INPUT_TOXINS_LAB "toxinslab_in"
#define ATMOS_GAS_MONITOR_OUTPUT_TOXINS_LAB "toxinslab_out"
#define ATMOS_GAS_MONITOR_SENSOR_TOXINS_LAB "toxinslab_sensor"

#define ATMOS_GAS_MONITOR_LOOP_DISTRIBUTION "distro-loop_meter"
#define ATMOS_GAS_MONITOR_LOOP_ATMOS_WASTE "atmos-waste_loop_meter"

#define ATMOS_GAS_MONITOR_WASTE_ENGINE "engine-waste_out"
#define ATMOS_GAS_MONITOR_WASTE_ATMOS "atmos-waste_out"

#define ATMOS_GAS_MONITOR_INPUT_SM "sm_in"
#define ATMOS_GAS_MONITOR_OUTPUT_SM "sm_out"
#define ATMOS_GAS_MONITOR_SENSOR_SM "sm_sense"

//AIRLOCK CONTROLLER TAGS

//RnD toxins burn chamber
#define INCINERATOR_TOXMIX_IGNITER 				"toxmix_igniter"
#define INCINERATOR_TOXMIX_VENT 				"toxmix_vent"
#define INCINERATOR_TOXMIX_DP_VENTPUMP			"toxmix_airlock_pump"
#define INCINERATOR_TOXMIX_AIRLOCK_SENSOR 		"toxmix_airlock_sensor"
#define INCINERATOR_TOXMIX_AIRLOCK_CONTROLLER 	"toxmix_airlock_controller"
#define INCINERATOR_TOXMIX_AIRLOCK_INTERIOR 	"toxmix_airlock_interior"
#define INCINERATOR_TOXMIX_AIRLOCK_EXTERIOR 	"toxmix_airlock_exterior"

//Atmospherics/maintenance incinerator
#define INCINERATOR_ATMOS_IGNITER 				"atmos_incinerator_igniter"
#define INCINERATOR_ATMOS_MAINVENT 				"atmos_incinerator_mainvent"
#define INCINERATOR_ATMOS_AUXVENT 				"atmos_incinerator_auxvent"
#define INCINERATOR_ATMOS_DP_VENTPUMP			"atmos_incinerator_airlock_pump"
#define INCINERATOR_ATMOS_AIRLOCK_SENSOR 		"atmos_incinerator_airlock_sensor"
#define INCINERATOR_ATMOS_AIRLOCK_CONTROLLER	"atmos_incinerator_airlock_controller"
#define INCINERATOR_ATMOS_AIRLOCK_INTERIOR 		"atmos_incinerator_airlock_interior"
#define INCINERATOR_ATMOS_AIRLOCK_EXTERIOR 		"atmos_incinerator_airlock_exterior"

//Syndicate lavaland base incinerator (lavaland_surface_syndicate_base1.dmm)
#define INCINERATOR_SYNDICATELAVA_IGNITER 				"syndicatelava_igniter"
#define INCINERATOR_SYNDICATELAVA_MAINVENT 				"syndicatelava_mainvent"
#define INCINERATOR_SYNDICATELAVA_AUXVENT 				"syndicatelava_auxvent"
#define INCINERATOR_SYNDICATELAVA_DP_VENTPUMP			"syndicatelava_airlock_pump"
#define INCINERATOR_SYNDICATELAVA_AIRLOCK_SENSOR 		"syndicatelava_airlock_sensor"
#define INCINERATOR_SYNDICATELAVA_AIRLOCK_CONTROLLER 	"syndicatelava_airlock_controller"
#define INCINERATOR_SYNDICATELAVA_AIRLOCK_INTERIOR 		"syndicatelava_airlock_interior"
#define INCINERATOR_SYNDICATELAVA_AIRLOCK_EXTERIOR	 	"syndicatelava_airlock_exterior"

//MULTIPIPES
//IF YOU EVER CHANGE THESE CHANGE SPRITES TO MATCH.
#define PIPING_LAYER_MIN 1
#define PIPING_LAYER_MAX 5
#define PIPING_LAYER_DEFAULT 3
#define PIPING_LAYER_P_X 5
#define PIPING_LAYER_P_Y 5
#define PIPING_LAYER_LCHANGE 0.05

#define PIPING_ALL_LAYER				(1<<0)	//! intended to connect with all layers, check for all instead of just one.
#define PIPING_ONE_PER_TURF				(1<<1) 	//! can only be built if nothing else with this flag is on the tile already.
#define PIPING_DEFAULT_LAYER_ONLY		(1<<2)	//! can only exist at PIPING_LAYER_DEFAULT
#define PIPING_CARDINAL_AUTONORMALIZE	(1<<3)	//! north/south east/west doesn't matter, auto normalize on build.

// Gas defines because i hate typepaths
#define GAS_O2					"o2"
#define GAS_N2					"n2"
#define GAS_CO2					"co2"
#define GAS_PLASMA				"plasma"
#define GAS_H2O					"water_vapor"
#define GAS_HYPERNOB			"nob"
#define GAS_NITROUS				"n2o"
#define GAS_NITRYL				"no2"
#define GAS_TRITIUM				"tritium"
#define GAS_BZ					"bz"
#define GAS_STIMULUM			"stim"
#define GAS_PLUOXIUM			"pluox"
#define GAS_MIASMA				"miasma"
#define GAS_GROUP_CHEMICALS 	"Chemicals"
#define GAS_BROMINE				"bromine"
#define GAS_AMMONIA				"ammonia"
#define GAS_FLUORINE			"fluorine"
#define GAS_ETHANOL				"ethanol"
#define GAS_H2					"hydrogen"
#define GAS_FREON				"freon"
#define GAS_HEALIUM				"healium"
#define GAS_PLUONIUM			"pluonium"
#define GAS_HALON				"halon"
#define GAS_ZAUKER				"zauker"
#define GAS_HEXANE				"hexane"
#define GAS_DILITHIUM			"dilithium"
//NUCLEIUM added. Waste Gas from RBMK Nuclear Reactor	//Monkestation Edit
#define GAS_NUCLEIUM			"nucleium"

#define GAS_FLAG_DANGEROUS		(1<<0)
#define GAS_FLAG_BREATH_PROC	(1<<1)
#define GAS_FLAG_CHEMICAL 		(1<<2)

//SUPERMATTER DEFINES
#define HEAT_PENALTY "heat penalties"
#define TRANSMIT_MODIFIER "transmit"
#define RADIOACTIVITY_MODIFIER "radioactivity"
#define HEAT_RESISTANCE "heat resistance"
#define POWERLOSS_INHIBITION "powerloss inhibition"
#define ALL_SUPERMATTER_GASES "gases we care about"
#define POWER_MIX "gas powermix"

//COLD FUSION DEFINES
/// This is the minimum possible required temperature that dilithium can lower fusion to.
#define FUSION_TEMPERATURE_THRESHOLD_MINIMUM 425
/// Affects how much Dilithium is required to get the required fusion temperature down to FUSION_TEMPERATURE_THRESHOLD_MINIMUM
#define DILITHIUM_LAMBDA 0.0087

//HELPERS
#define PIPING_LAYER_SHIFT(T, PipingLayer) \
	if(T.dir & (NORTH|SOUTH)) {									\
		T.pixel_x = (PipingLayer - PIPING_LAYER_DEFAULT) * PIPING_LAYER_P_X;\
	}																		\
	if(T.dir & (EAST|WEST)) {										\
		T.pixel_y = (PipingLayer - PIPING_LAYER_DEFAULT) * PIPING_LAYER_P_Y;\
	}

#define PIPING_FORWARD_SHIFT(T, PipingLayer, more_shift) \
	if(T.dir & (NORTH|SOUTH)) {									\
		T.pixel_y += more_shift * (PipingLayer - PIPING_LAYER_DEFAULT);\
	}																		\
	if(T.dir & (EAST|WEST)) {										\
		T.pixel_x += more_shift * (PipingLayer - PIPING_LAYER_DEFAULT);\
	}

#define PIPING_LAYER_DOUBLE_SHIFT(T, PipingLayer) \
	T.pixel_x = (PipingLayer - PIPING_LAYER_DEFAULT) * PIPING_LAYER_P_X;\
	T.pixel_y = (PipingLayer - PIPING_LAYER_DEFAULT) * PIPING_LAYER_P_Y;

#ifdef TESTING
GLOBAL_LIST_INIT(atmos_adjacent_savings, list(0,0))
#define CALCULATE_ADJACENT_TURFS(T) if (SSadjacent_air.queue[T]) { GLOB.atmos_adjacent_savings[1] += 1 } else { GLOB.atmos_adjacent_savings[2] += 1; SSadjacent_air.queue[T] = 1 }
#else
#define CALCULATE_ADJACENT_TURFS(T) SSadjacent_air.queue[T] = 1
#endif

//PIPENET UPDATE STATUS
#define PIPENET_UPDATE_STATUS_DORMANT 0
#define PIPENET_UPDATE_STATUS_REACT_NEEDED 1
#define PIPENET_UPDATE_STATUS_RECONCILE_NEEDED 2
