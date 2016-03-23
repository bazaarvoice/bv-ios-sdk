//
//  BVContextualValues.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
// This file defines all Contextual Interest Tier 1 and Contextual Interest Tier 2 interest strings.
// These values can be fed into BVAdsSDK via various location-powered methods defined in BVAdsSDK.h
// Note that tier 2 interests are "children" of tier 1 interests.
//     Ex: Tier 1: "tierOneSports"
//         Tier 2: "tierTwoSportsBaseball"

#import <Foundation/Foundation.h>

/*
 *  BVContextualInterest
 *
 *  Discussion:
 *    Type used to represent contextual interest category.
 */
typedef NSString BVContextualInterest;


/// Contextual Interests Tier 1:
static BVContextualInterest* tierOneTravel = @"travel";
static BVContextualInterest* tierOneFamilyAndParenting = @"familyandparenting";
static BVContextualInterest* tierOneTechnologyAndComputing = @"technologyandcomputing";
static BVContextualInterest* tierOneApparelAndAccessories = @"apparelandaccessories";
static BVContextualInterest* tierOnePets = @"pets";
static BVContextualInterest* tierOneCareers = @"careers";
static BVContextualInterest* tierOneUncategorized = @"uncategorized";
static BVContextualInterest* tierOneShopping = @"shopping";
static BVContextualInterest* tierOneBeauty = @"beauty";
static BVContextualInterest* tierOneSociety = @"society";
static BVContextualInterest* tierOneAutomotive = @"automotive";
static BVContextualInterest* tierOnePersonalFinance = @"personalfinance";
static BVContextualInterest* tierOneHealthAndFitness = @"healthandfitness";
static BVContextualInterest* tierOneNews = @"news";
static BVContextualInterest* tierOneScience = @"science";
static BVContextualInterest* tierOneArtsAndEntertainment = @"artsandentertainment";
static BVContextualInterest* tierOneFoodAndDrink = @"foodanddrink";
static BVContextualInterest* tierOneSports = @"sports";
static BVContextualInterest* tierOneBusiness = @"business";
static BVContextualInterest* tierOneReligionandSpirituality = @"religionandspirituality";
static BVContextualInterest* tierOneHomeAndGarden = @"homeandgarden";
static BVContextualInterest* tierOneHobbiesAndInterests = @"hobbiesandinterests";
static BVContextualInterest* tierOneSportingGoods = @"sportinggoods";
static BVContextualInterest* tierOneEducation = @"education";
static BVContextualInterest* tierOneConsumerElectronics = @"consumerelectronics";
static BVContextualInterest* tierOneRealEstate = @"realestate";
static BVContextualInterest* tierOneStyleAndFashion = @"styleandfashion";

/// Contextual Interests Tier 2: Travel
static BVContextualInterest* tierTwoTravelAdventureTravel = @"adventuretravel";
static BVContextualInterest* tierTwoTravelAfrica = @"africa";
static BVContextualInterest* tierTwoTravelAirTravel = @"airtravel";
static BVContextualInterest* tierTwoTravelAustraliaAndNewZealand = @"australiaandnewzealand";
static BVContextualInterest* tierTwoTravelBedAndBreakfasts = @"bedandbreakfasts";
static BVContextualInterest* tierTwoTravelBudgeTravel = @"budgetravel";
static BVContextualInterest* tierTwoTravelBusinessTravel = @"businesstravel";
static BVContextualInterest* tierTwoTravelByUSLocale = @"byuslocale";
static BVContextualInterest* tierTwoTravelCamping = @"camping";
static BVContextualInterest* tierTwoTravelCanada = @"canada";
static BVContextualInterest* tierTwoTravelCaribbean = @"caribbean";
static BVContextualInterest* tierTwoTravelCruises = @"cruises";
static BVContextualInterest* tierTwoTravelEasternEurope = @"easterneurope";
static BVContextualInterest* tierTwoTravelEurope = @"europe";
static BVContextualInterest* tierTwoTravelFrance = @"france";
static BVContextualInterest* tierTwoTravelGreece = @"greece";
static BVContextualInterest* tierTwoTravelHoneymoonsGetaways = @"honeymoonsgetaways";
static BVContextualInterest* tierTwoTravelHotels = @"hotels";
static BVContextualInterest* tierTwoTravelItaly = @"italy";
static BVContextualInterest* tierTwoTravelJapan = @"japan";
static BVContextualInterest* tierTwoTravelMexicoAndCentralAmerica = @"mexicoandcentralamerica";
static BVContextualInterest* tierTwoTravelNationalParks = @"nationalparks";
static BVContextualInterest* tierTwoTravelSouthAmerica = @"southamerica";
static BVContextualInterest* tierTwoTravelSpas = @"spas";
static BVContextualInterest* tierTwoTravelThemeParks = @"themeparks";
static BVContextualInterest* tierTwoTravelTravelingwithKids = @"travelingwithkids";
static BVContextualInterest* tierTwoTravelUnitedKingdom = @"unitedkingdom";

/// Contextual Interests Tier 2: Family & Parenting
static BVContextualInterest* tierTwoFamilyAndParentingAdoption = @"adoption";
static BVContextualInterest* tierTwoFamilyAndParentingBabiesAndToddlers = @"babiesandtoddlers";
static BVContextualInterest* tierTwoFamilyAndParentingDaycarePreSchool = @"daycarepreschool";
static BVContextualInterest* tierTwoFamilyAndParentingEldercare = @"eldercare";
static BVContextualInterest* tierTwoFamilyAndParentingFamilyInternet = @"familyinternet";
static BVContextualInterest* tierTwoFamilyAndParentingParentingK6Kids = @"parentingk6kids";
static BVContextualInterest* tierTwoFamilyAndParentingParentingTeens = @"parentingteens";
static BVContextualInterest* tierTwoFamilyAndParentingPregnancy = @"pregnancy";
static BVContextualInterest* tierTwoFamilyAndParentingSpecialNeedsKids = @"specialneedskids";

/// Contextual Interests Tier 2: Technology & Computing
static BVContextualInterest* tierTwoTechnologyAndComputing3DGraphics = @"3dgraphics";
static BVContextualInterest* tierTwoTechnologyAndComputingAnimation = @"animation";
static BVContextualInterest* tierTwoTechnologyAndComputingAntivirusSoftware = @"antivirussoftware";
static BVContextualInterest* tierTwoTechnologyAndComputingCC = @"cc";
static BVContextualInterest* tierTwoTechnologyAndComputingCamerasAndCamcorders = @"camerasandcamcorders";
static BVContextualInterest* tierTwoTechnologyAndComputingCellPhones = @"cellphones";
static BVContextualInterest* tierTwoTechnologyAndComputingComputerCertification = @"computercertification";
static BVContextualInterest* tierTwoTechnologyAndComputingComputerNetworking = @"computernetworking";
static BVContextualInterest* tierTwoTechnologyAndComputingComputerPeripherals = @"computerperipherals";
static BVContextualInterest* tierTwoTechnologyAndComputingComputerReviews = @"computerreviews";
static BVContextualInterest* tierTwoTechnologyAndComputingDataCenters = @"datacenters";
static BVContextualInterest* tierTwoTechnologyAndComputingDatabases = @"databases";
static BVContextualInterest* tierTwoTechnologyAndComputingDesktopPublishing = @"desktoppublishing";
static BVContextualInterest* tierTwoTechnologyAndComputingDesktopVideo = @"desktopvideo";
static BVContextualInterest* tierTwoTechnologyAndComputingEmail = @"email";
static BVContextualInterest* tierTwoTechnologyAndComputingGraphicsSoftware = @"graphicssoftware";
static BVContextualInterest* tierTwoTechnologyAndComputingHomeVideoDVD = @"homevideodvd";
static BVContextualInterest* tierTwoTechnologyAndComputingInternetTechnology = @"internettechnology";
static BVContextualInterest* tierTwoTechnologyAndComputingJava = @"java";
static BVContextualInterest* tierTwoTechnologyAndComputingJavaScript = @"javascript";
static BVContextualInterest* tierTwoTechnologyAndComputingLinux = @"linux";
static BVContextualInterest* tierTwoTechnologyAndComputingMacOS = @"macos";
static BVContextualInterest* tierTwoTechnologyAndComputingMacSupport = @"macsupport";
static BVContextualInterest* tierTwoTechnologyAndComputingMP3MIDI = @"mp3midi";
static BVContextualInterest* tierTwoTechnologyAndComputingNetConferencing = @"netconferencing";
static BVContextualInterest* tierTwoTechnologyAndComputingNetforBeginners = @"netforbeginners";
static BVContextualInterest* tierTwoTechnologyAndComputingNetworkSecurity = @"networksecurity";
static BVContextualInterest* tierTwoTechnologyAndComputingPalmtopsPDAs = @"palmtopspdas";
static BVContextualInterest* tierTwoTechnologyAndComputingPCSupport = @"pcsupport";
static BVContextualInterest* tierTwoTechnologyAndComputingPortableEntertainment = @"portableentertainment";
static BVContextualInterest* tierTwoTechnologyAndComputingSharewareFreeware = @"sharewarefreeware";
static BVContextualInterest* tierTwoTechnologyAndComputingUnix = @"unix";
static BVContextualInterest* tierTwoTechnologyAndComputingVisualBasic = @"visualbasic";
static BVContextualInterest* tierTwoTechnologyAndComputingWebClipArt = @"webclipart";
static BVContextualInterest* tierTwoTechnologyAndComputingWebDesignHTML = @"webdesignhtml";
static BVContextualInterest* tierTwoTechnologyAndComputingWebSearch = @"websearch";
static BVContextualInterest* tierTwoTechnologyAndComputingWindows = @"windows";

/// Contextual Interests Tier 2: Apparel & Accessories
static BVContextualInterest* tierTwoApparelAndAccessoriesEngagementRings = @"engagementrings";
static BVContextualInterest* tierTwoApparelAndAccessoriesFashionJewelry = @"fashionjewelry";
static BVContextualInterest* tierTwoApparelAndAccessoriesHairAccessories = @"hairaccessories";
static BVContextualInterest* tierTwoApparelAndAccessoriesHandbags = @"handbags";
static BVContextualInterest* tierTwoApparelAndAccessoriesJewelryAndWatches = @"jewelryandwatches";
static BVContextualInterest* tierTwoApparelAndAccessoriesMensApparel = @"mensapparel";
static BVContextualInterest* tierTwoApparelAndAccessoriesMensAthleticApparel = @"mensathleticapparel";
static BVContextualInterest* tierTwoApparelAndAccessoriesMensBusinessAttire = @"mensbusinessattire";
static BVContextualInterest* tierTwoApparelAndAccessoriesMensCasualAttire = @"menscasualattire";
static BVContextualInterest* tierTwoApparelAndAccessoriesMensShoes = @"mensshoes";
static BVContextualInterest* tierTwoApparelAndAccessoriesMensSwimwear = @"mensswimwear";
static BVContextualInterest* tierTwoApparelAndAccessoriesSunglasses = @"sunglasses";
static BVContextualInterest* tierTwoApparelAndAccessoriesWallets = @"wallets";
static BVContextualInterest* tierTwoApparelAndAccessoriesWatches = @"watches";
static BVContextualInterest* tierTwoApparelAndAccessoriesWomensShoes = @"womensshoes";
static BVContextualInterest* tierTwoApparelAndAccessoriesWomensApparel = @"womensapparel";
static BVContextualInterest* tierTwoApparelAndAccessoriesWomensAthleticApparel = @"womensathleticapparel";
static BVContextualInterest* tierTwoApparelAndAccessoriesWomensBusinessAttire = @"womensbusinessattire";
static BVContextualInterest* tierTwoApparelAndAccessoriesWomensCoatsAndJackets = @"womenscoatsandjackets";
static BVContextualInterest* tierTwoApparelAndAccessoriesWomensDresses = @"womensdresses";
static BVContextualInterest* tierTwoApparelAndAccessoriesWomensJeans = @"womensjeans";
static BVContextualInterest* tierTwoApparelAndAccessoriesWomensMaternity = @"womensmaternity";
static BVContextualInterest* tierTwoApparelAndAccessoriesWomensSwimwear = @"womensswimwear";

/// Contextual Interests Tier 2: Pets
static BVContextualInterest* tierTwoPetsAquariums = @"aquariums";
static BVContextualInterest* tierTwoPetsBirds = @"birds";
static BVContextualInterest* tierTwoPetsCats = @"cats";
static BVContextualInterest* tierTwoPetsDogs = @"dogs";
static BVContextualInterest* tierTwoPetsLargeAnimals = @"largeanimals";
static BVContextualInterest* tierTwoPetsReptiles = @"reptiles";
static BVContextualInterest* tierTwoPetsVeterinaryMedicine = @"veterinarymedicine";

/// Contextual Interests Tier 2: Careers
static BVContextualInterest* tierTwoCareersCareerAdvice = @"careeradvice";
static BVContextualInterest* tierTwoCareersCareerPlanning = @"careerplanning";
static BVContextualInterest* tierTwoCareersCollege = @"college";
static BVContextualInterest* tierTwoCareersFinancialAid = @"financialaid";
static BVContextualInterest* tierTwoCareersJobFairs = @"jobfairs";
static BVContextualInterest* tierTwoCareersJobSearch = @"jobsearch";
static BVContextualInterest* tierTwoCareersNursing = @"nursing";
static BVContextualInterest* tierTwoCareersResumeWritingAdvice = @"resumewritingadvice";
static BVContextualInterest* tierTwoCareersScholarships = @"scholarships";
static BVContextualInterest* tierTwoCareersTelecommuting = @"telecommuting";
static BVContextualInterest* tierTwoCareersUSMilitary = @"usmilitary";

/// Contextual Interests Tier 2: Uncategorized
static BVContextualInterest* tierTwoUncategorizedSocialMedia = @"socialmedia";

/// Contextual Interests Tier 2: Shopping
static BVContextualInterest* tierTwoShoppingComparison = @"comparison";
static BVContextualInterest* tierTwoShoppingContestsAndFreebies = @"contestsandfreebies";
static BVContextualInterest* tierTwoShoppingCouponing = @"couponing";
static BVContextualInterest* tierTwoShoppingEngines = @"engines";

/// Contextual Interests Tier 2: Beauty
static BVContextualInterest* tierTwoBeautyFragrance = @"fragrance";
static BVContextualInterest* tierTwoBeautyHairCare = @"haircare";
static BVContextualInterest* tierTwoBeautyMakeup = @"makeup";
static BVContextualInterest* tierTwoBeautyNailCare = @"nailcare";
static BVContextualInterest* tierTwoBeautySkinCare = @"skincare";

/// Contextual Interests Tier 2: Society
static BVContextualInterest* tierTwoSocietyDating = @"dating";
static BVContextualInterest* tierTwoSocietyDivorceSupport = @"divorcesupport";
static BVContextualInterest* tierTwoSocietyEthnicSpecific = @"ethnicspecific";
static BVContextualInterest* tierTwoSocietyGayLife = @"gaylife";
static BVContextualInterest* tierTwoSocietyMarriage = @"marriage";
static BVContextualInterest* tierTwoSocietySeniorLiving = @"seniorliving";
static BVContextualInterest* tierTwoSocietyTeens = @"teens";
static BVContextualInterest* tierTwoSocietyWeddings = @"weddings";

/// Contextual Interests Tier 2: Automotive
static BVContextualInterest* tierTwoAutomotiveAutoParts = @"autoparts";
static BVContextualInterest* tierTwoAutomotiveAutoRepair = @"autorepair";
static BVContextualInterest* tierTwoAutomotiveBuyingSellingCars = @"buyingsellingcars";
static BVContextualInterest* tierTwoAutomotiveCarCulture = @"carculture";
static BVContextualInterest* tierTwoAutomotiveCertifiedPreOwned = @"certifiedpreowned";
static BVContextualInterest* tierTwoAutomotiveConvertible = @"convertible";
static BVContextualInterest* tierTwoAutomotiveCoupe = @"coupe";
static BVContextualInterest* tierTwoAutomotiveCrossover = @"crossover";
static BVContextualInterest* tierTwoAutomotiveDiesel = @"diesel";
static BVContextualInterest* tierTwoAutomotiveElectricVehicle = @"electricvehicle";
static BVContextualInterest* tierTwoAutomotiveHatchback = @"hatchback";
static BVContextualInterest* tierTwoAutomotiveHybrid = @"hybrid";
static BVContextualInterest* tierTwoAutomotiveLuxury = @"luxury";
static BVContextualInterest* tierTwoAutomotiveMinivan = @"minivan";
static BVContextualInterest* tierTwoAutomotiveMotorcycles = @"motorcycles";
static BVContextualInterest* tierTwoAutomotiveOffRoadVehicles = @"offroadvehicles";
static BVContextualInterest* tierTwoAutomotivePerformanceVehicles = @"performancevehicles";
static BVContextualInterest* tierTwoAutomotivePickup = @"pickup";
static BVContextualInterest* tierTwoAutomotiveRoadSideAssistance = @"roadsideassistance";
static BVContextualInterest* tierTwoAutomotiveSedan = @"sedan";
static BVContextualInterest* tierTwoAutomotiveTrucksAndAccessories = @"trucksandaccessories";
static BVContextualInterest* tierTwoAutomotiveVintageCars = @"vintagecars";
static BVContextualInterest* tierTwoAutomotiveWagon = @"wagon";

/// Contextual Interests Tier 2: Personal Finance
static BVContextualInterest* tierTwoPersonalFinanceBeginningInvesting = @"beginninginvesting";
static BVContextualInterest* tierTwoPersonalFinanceCreditDebtAndLoans = @"creditdebtandloans";
static BVContextualInterest* tierTwoPersonalFinanceFinancialNews = @"financialnews";
static BVContextualInterest* tierTwoPersonalFinanceFinancialPlanning = @"financialplanning";
static BVContextualInterest* tierTwoPersonalFinanceHedgeFund = @"hedgefund";
static BVContextualInterest* tierTwoPersonalFinanceInsurance = @"insurance";
static BVContextualInterest* tierTwoPersonalFinanceInvesting = @"investing";
static BVContextualInterest* tierTwoPersonalFinanceMutualFunds = @"mutualfunds";
static BVContextualInterest* tierTwoPersonalFinanceOptions = @"options";
static BVContextualInterest* tierTwoPersonalFinanceRetirementPlanning = @"retirementplanning";
static BVContextualInterest* tierTwoPersonalFinanceStocks = @"stocks";
static BVContextualInterest* tierTwoPersonalFinanceTaxPlanning = @"taxplanning";

/// Contextual Interests Tier 2: Health & Fitness
static BVContextualInterest* tierTwoHealthAndFitnessADD = @"add";
static BVContextualInterest* tierTwoHealthAndFitnessAIDSHIV = @"aidshiv";
static BVContextualInterest* tierTwoHealthAndFitnessAllergies = @"allergies";
static BVContextualInterest* tierTwoHealthAndFitnessAlternativeMedicine = @"alternativemedicine";
static BVContextualInterest* tierTwoHealthAndFitnessArthritis = @"arthritis";
static BVContextualInterest* tierTwoHealthAndFitnessAsthma = @"asthma";
static BVContextualInterest* tierTwoHealthAndFitnessAutismPDD = @"autismpdd";
static BVContextualInterest* tierTwoHealthAndFitnessBipolarDisorder = @"bipolardisorder";
static BVContextualInterest* tierTwoHealthAndFitnessBrainTumor = @"braintumor";
static BVContextualInterest* tierTwoHealthAndFitnessCancer = @"cancer";
static BVContextualInterest* tierTwoHealthAndFitnessCholesterol = @"cholesterol";
static BVContextualInterest* tierTwoHealthAndFitnessChronicFatigueSyndrome = @"chronicfatiguesyndrome";
static BVContextualInterest* tierTwoHealthAndFitnessChronicPain = @"chronicpain";
static BVContextualInterest* tierTwoHealthAndFitnessColdAndFlu = @"coldandflu";
static BVContextualInterest* tierTwoHealthAndFitnessDeafness = @"deafness";
static BVContextualInterest* tierTwoHealthAndFitnessDentalCare = @"dentalcare";
static BVContextualInterest* tierTwoHealthAndFitnessDepression = @"depression";
static BVContextualInterest* tierTwoHealthAndFitnessDermatology = @"dermatology";
static BVContextualInterest* tierTwoHealthAndFitnessDiabetes = @"diabetes";
static BVContextualInterest* tierTwoHealthAndFitnessEpilepsy = @"epilepsy";
static BVContextualInterest* tierTwoHealthAndFitnessExercise = @"exercise";
static BVContextualInterest* tierTwoHealthAndFitnessGERDAcidReflux = @"gerdacidreflux";
static BVContextualInterest* tierTwoHealthAndFitnessHeadachesMigraines = @"headachesmigraines";
static BVContextualInterest* tierTwoHealthAndFitnessHeartDisease = @"heartdisease";
static BVContextualInterest* tierTwoHealthAndFitnessHerbsforHealth = @"herbsforhealth";
static BVContextualInterest* tierTwoHealthAndFitnessHolisticHealing = @"holistichealing";
static BVContextualInterest* tierTwoHealthAndFitnessIBSCrohnsDisease = @"ibscrohnsdisease";
static BVContextualInterest* tierTwoHealthAndFitnessIncestAbuseSupport = @"incestabusesupport";
static BVContextualInterest* tierTwoHealthAndFitnessIncontinence = @"incontinence";
static BVContextualInterest* tierTwoHealthAndFitnessInfertility = @"infertility";
static BVContextualInterest* tierTwoHealthAndFitnessMensHealth = @"menshealth";
static BVContextualInterest* tierTwoHealthAndFitnessNutrition = @"nutrition";
static BVContextualInterest* tierTwoHealthAndFitnessOrthopedics = @"orthopedics";
static BVContextualInterest* tierTwoHealthAndFitnessPanicAnxietyDisorders = @"panicanxietydisorders";
static BVContextualInterest* tierTwoHealthAndFitnessPediatrics = @"pediatrics";
static BVContextualInterest* tierTwoHealthAndFitnessPhysicalTherapy = @"physicaltherapy";
static BVContextualInterest* tierTwoHealthAndFitnessPsychologyPsychiatry = @"psychologypsychiatry";
static BVContextualInterest* tierTwoHealthAndFitnessSeniorHealth = @"seniorhealth";
static BVContextualInterest* tierTwoHealthAndFitnessSexuality = @"sexuality";
static BVContextualInterest* tierTwoHealthAndFitnessSleepDisorders = @"sleepdisorders";
static BVContextualInterest* tierTwoHealthAndFitnessSmokingCessation = @"smokingcessation";
static BVContextualInterest* tierTwoHealthAndFitnessSubstanceAbuse = @"substanceabuse";
static BVContextualInterest* tierTwoHealthAndFitnessThyroidDisease = @"thyroiddisease";
static BVContextualInterest* tierTwoHealthAndFitnessWeightLoss = @"weightloss";
static BVContextualInterest* tierTwoHealthAndFitnessWomensHealth = @"womenshealth";

/// Contextual Interests Tier 2: News
static BVContextualInterest* tierTwoNewsInternationalNews = @"internationalnews";
static BVContextualInterest* tierTwoNewsLocalNews = @"localnews";
static BVContextualInterest* tierTwoNewsNationalNews = @"nationalnews";

/// Contextual Interests Tier 2: Science
static BVContextualInterest* tierTwoScienceAstrology = @"astrology";
static BVContextualInterest* tierTwoScienceBiology = @"biology";
static BVContextualInterest* tierTwoScienceBotany = @"botany";
static BVContextualInterest* tierTwoScienceChemistry = @"chemistry";
static BVContextualInterest* tierTwoScienceGeography = @"geography";
static BVContextualInterest* tierTwoScienceGeology = @"geology";
static BVContextualInterest* tierTwoScienceParanormalPhenomena = @"paranormalphenomena";
static BVContextualInterest* tierTwoSciencePhysics = @"physics";
static BVContextualInterest* tierTwoScienceSpaceAstronomy = @"spaceastronomy";
static BVContextualInterest* tierTwoScienceWeather = @"weather";

/// Contextual Interests Tier 2: Arts & Entertainment
static BVContextualInterest* tierTwoArtsAndEntertainmentBooksAndLiterature = @"booksandliterature";
static BVContextualInterest* tierTwoArtsAndEntertainmentCelebrityFanGossip = @"celebrityfangossip";
static BVContextualInterest* tierTwoArtsAndEntertainmentFineArt = @"fineart";
static BVContextualInterest* tierTwoArtsAndEntertainmentHumor = @"humor";
static BVContextualInterest* tierTwoArtsAndEntertainmentMovies = @"movies";
static BVContextualInterest* tierTwoArtsAndEntertainmentMusic = @"music";
static BVContextualInterest* tierTwoArtsAndEntertainmentTelevision = @"television";

/// Contextual Interests Tier 2: Food & Drink
static BVContextualInterest* tierTwoFoodAndDrinkAmericanCuisine = @"americancuisine";
static BVContextualInterest* tierTwoFoodAndDrinkBarbecuesAndGrilling = @"barbecuesandgrilling";
static BVContextualInterest* tierTwoFoodAndDrinkCajunCreole = @"cajuncreole";
static BVContextualInterest* tierTwoFoodAndDrinkChineseCuisine = @"chinesecuisine";
static BVContextualInterest* tierTwoFoodAndDrinkCocktailsBeer = @"cocktailsbeer";
static BVContextualInterest* tierTwoFoodAndDrinkCoffeeTea = @"coffeetea";
static BVContextualInterest* tierTwoFoodAndDrinkCuisineSpecific = @"cuisinespecific";
static BVContextualInterest* tierTwoFoodAndDrinkDessertsAndBaking = @"dessertsandbaking";
static BVContextualInterest* tierTwoFoodAndDrinkDiningOut = @"diningout";
static BVContextualInterest* tierTwoFoodAndDrinkFoodAllergies = @"foodallergies";
static BVContextualInterest* tierTwoFoodAndDrinkFrenchCuisine = @"frenchcuisine";
static BVContextualInterest* tierTwoFoodAndDrinkHealthLowFatCooking = @"healthlowfatcooking";
static BVContextualInterest* tierTwoFoodAndDrinkItalianCuisine = @"italiancuisine";
static BVContextualInterest* tierTwoFoodAndDrinkJapaneseCuisine = @"japanesecuisine";
static BVContextualInterest* tierTwoFoodAndDrinkMexicanCuisine = @"mexicancuisine";
static BVContextualInterest* tierTwoFoodAndDrinkVegan = @"vegan";
static BVContextualInterest* tierTwoFoodAndDrinkVegetarian = @"vegetarian";
static BVContextualInterest* tierTwoFoodAndDrinkWine = @"wine";

/// Contextual Interests Tier 2: Sports
static BVContextualInterest* tierTwoSportsAutoRacing = @"autoracing";
static BVContextualInterest* tierTwoSportsBaseball = @"baseball";
static BVContextualInterest* tierTwoSportsBicycling = @"bicycling";
static BVContextualInterest* tierTwoSportsBodybuilding = @"bodybuilding";
static BVContextualInterest* tierTwoSportsBoxing = @"boxing";
static BVContextualInterest* tierTwoSportsCanoeingKayaking = @"canoeingkayaking";
static BVContextualInterest* tierTwoSportsCheerleading = @"cheerleading";
static BVContextualInterest* tierTwoSportsClimbing = @"climbing";
static BVContextualInterest* tierTwoSportsCricket = @"cricket";
static BVContextualInterest* tierTwoSportsFigureSkating = @"figureskating";
static BVContextualInterest* tierTwoSportsFlyFishing = @"flyfishing";
static BVContextualInterest* tierTwoSportsFootball = @"football";
static BVContextualInterest* tierTwoSportsFreshwaterFishing = @"freshwaterfishing";
static BVContextualInterest* tierTwoSportsGameAndFish = @"gameandfish";
static BVContextualInterest* tierTwoSportsGolf = @"golf";
static BVContextualInterest* tierTwoSportsHorseRacing = @"horseracing";
static BVContextualInterest* tierTwoSportsHorses = @"horses";
static BVContextualInterest* tierTwoSportsHuntingShooting = @"huntingshooting";
static BVContextualInterest* tierTwoSportsInlineSkating = @"inlineskating";
static BVContextualInterest* tierTwoSportsMartialArts = @"martialarts";
static BVContextualInterest* tierTwoSportsMountainBiking = @"mountainbiking";
static BVContextualInterest* tierTwoSportsNASCARRacing = @"nascarracing";
static BVContextualInterest* tierTwoSportsOlympics = @"olympics";
static BVContextualInterest* tierTwoSportsPaintball = @"paintball";
static BVContextualInterest* tierTwoSportsPowerAndMotorcycles = @"powerandmotorcycles";
static BVContextualInterest* tierTwoSportsProBasketball = @"probasketball";
static BVContextualInterest* tierTwoSportsProIceHockey = @"proicehockey";
static BVContextualInterest* tierTwoSportsRodeo = @"rodeo";
static BVContextualInterest* tierTwoSportsRugby = @"rugby";
static BVContextualInterest* tierTwoSportsRunningJogging = @"runningjogging";
static BVContextualInterest* tierTwoSportsSailing = @"sailing";
static BVContextualInterest* tierTwoSportsSaltwaterFishing = @"saltwaterfishing";
static BVContextualInterest* tierTwoSportsScubaDiving = @"scubadiving";
static BVContextualInterest* tierTwoSportsSkateboarding = @"skateboarding";
static BVContextualInterest* tierTwoSportsSkiing = @"skiing";
static BVContextualInterest* tierTwoSportsSnowboarding = @"snowboarding";
static BVContextualInterest* tierTwoSportsSurfingBodyboarding = @"surfingbodyboarding";
static BVContextualInterest* tierTwoSportsSwimming = @"swimming";
static BVContextualInterest* tierTwoSportsTableTennisPingPong = @"tabletennispingpong";
static BVContextualInterest* tierTwoSportsTennis = @"tennis";
static BVContextualInterest* tierTwoSportsVolleyball = @"volleyball";
static BVContextualInterest* tierTwoSportsWalking = @"walking";
static BVContextualInterest* tierTwoSportsWaterskiWakeboard = @"waterskiwakeboard";
static BVContextualInterest* tierTwoSportsWorldSoccer = @"worldsoccer";

/// Contextual Interests Tier 2: Business
static BVContextualInterest* tierTwoBusinessAdvertising = @"advertising";
static BVContextualInterest* tierTwoBusinessAgriculture = @"agriculture";
static BVContextualInterest* tierTwoBusinessBiotechBiomedical = @"biotechbiomedical";
static BVContextualInterest* tierTwoBusinessBusinessSoftware = @"businesssoftware";
static BVContextualInterest* tierTwoBusinessBusinessSupplies = @"businesssupplies";
static BVContextualInterest* tierTwoBusinessConstruction = @"construction";
static BVContextualInterest* tierTwoBusinessForestry = @"forestry";
static BVContextualInterest* tierTwoBusinessGovernment = @"government";
static BVContextualInterest* tierTwoBusinessGreenSolutions = @"greensolutions";
static BVContextualInterest* tierTwoBusinessHumanResources = @"humanresources";
static BVContextualInterest* tierTwoBusinessLogistics = @"logistics";
static BVContextualInterest* tierTwoBusinessMarketing = @"marketing";
static BVContextualInterest* tierTwoBusinessMetals = @"metals";
static BVContextualInterest* tierTwoBusinessRestaurant = @"restaurant";

/// Contextual Interests Tier 2: Religion and Spirituality
static BVContextualInterest* tierTwoReligionandSpiritualityAlternativeReligions = @"alternativereligions";
static BVContextualInterest* tierTwoReligionandSpiritualityAtheismAgnosticism = @"atheismagnosticism";
static BVContextualInterest* tierTwoReligionandSpiritualityBuddhism = @"buddhism";
static BVContextualInterest* tierTwoReligionandSpiritualityCatholicism = @"catholicism";
static BVContextualInterest* tierTwoReligionandSpiritualityChristianity = @"christianity";
static BVContextualInterest* tierTwoReligionandSpiritualityHinduism = @"hinduism";
static BVContextualInterest* tierTwoReligionandSpiritualityIslam = @"islam";
static BVContextualInterest* tierTwoReligionandSpiritualityJudaism = @"judaism";
static BVContextualInterest* tierTwoReligionandSpiritualityLatterDaySaints = @"latterdaysaints";
static BVContextualInterest* tierTwoReligionandSpiritualityPaganWiccan = @"paganwiccan";

/// Contextual Interests Tier 2: Home & Garden
static BVContextualInterest* tierTwoHomeAndGardenAppliances = @"appliances";
static BVContextualInterest* tierTwoHomeAndGardenBath = @"bath";
static BVContextualInterest* tierTwoHomeAndGardenBedding = @"bedding";
static BVContextualInterest* tierTwoHomeAndGardenBuildingAndHardware = @"buildingandhardware";
static BVContextualInterest* tierTwoHomeAndGardenCoffeeMakers = @"coffeemakers";
static BVContextualInterest* tierTwoHomeAndGardenElectricalAndSolar = @"electricalandsolar";
static BVContextualInterest* tierTwoHomeAndGardenEntertaining = @"entertaining";
static BVContextualInterest* tierTwoHomeAndGardenEnvironmentalSafety = @"environmentalsafety";
static BVContextualInterest* tierTwoHomeAndGardenFurniture = @"furniture";
static BVContextualInterest* tierTwoHomeAndGardenGardening = @"gardening";
static BVContextualInterest* tierTwoHomeAndGardenHeatingCoolingAndAir = @"heatingcoolingandair";
static BVContextualInterest* tierTwoHomeAndGardenHomeDecor = @"homedecor";
static BVContextualInterest* tierTwoHomeAndGardenHomeRepair = @"homerepair";
static BVContextualInterest* tierTwoHomeAndGardenHomeSecurity = @"homesecurity";
static BVContextualInterest* tierTwoHomeAndGardenHomeTheater = @"hometheater";
static BVContextualInterest* tierTwoHomeAndGardenHousekeepingAndOrganization = @"housekeepingandorganization";
static BVContextualInterest* tierTwoHomeAndGardenInteriorDecorating = @"interiordecorating";
static BVContextualInterest* tierTwoHomeAndGardenKitchenAndDining = @"kitchenanddining";
static BVContextualInterest* tierTwoHomeAndGardenLampsAndLighting = @"lampsandlighting";
static BVContextualInterest* tierTwoHomeAndGardenLandscaping = @"landscaping";
static BVContextualInterest* tierTwoHomeAndGardenMajorAppliances = @"majorappliances";
static BVContextualInterest* tierTwoHomeAndGardenOutdoor = @"outdoor";
static BVContextualInterest* tierTwoHomeAndGardenOutdoorLiving = @"outdoorliving";
static BVContextualInterest* tierTwoHomeAndGardenPlumbingAndFixtures = @"plumbingandfixtures";
static BVContextualInterest* tierTwoHomeAndGardenRemodelingAndConstruction = @"remodelingandconstruction";
static BVContextualInterest* tierTwoHomeAndGardenRugsAndCarpets = @"rugsandcarpets";
static BVContextualInterest* tierTwoHomeAndGardenSmallAppliances = @"smallappliances";
static BVContextualInterest* tierTwoHomeAndGardenTools = @"tools";
static BVContextualInterest* tierTwoHomeAndGardenWindowTreatments = @"windowtreatments";
static BVContextualInterest* tierTwoHomeAndGardenYardAndGarden = @"yardandgarden";

/// Contextual Interests Tier 2: Hobbies & Interests
static BVContextualInterest* tierTwoHobbiesAndInterestsArtTechnology = @"arttechnology";
static BVContextualInterest* tierTwoHobbiesAndInterestsArtsAndCrafts = @"artsandcrafts";
static BVContextualInterest* tierTwoHobbiesAndInterestsBeadwork = @"beadwork";
static BVContextualInterest* tierTwoHobbiesAndInterestsBirdwatching = @"birdwatching";
static BVContextualInterest* tierTwoHobbiesAndInterestsBoardGamesPuzzles = @"boardgamespuzzles";
static BVContextualInterest* tierTwoHobbiesAndInterestsCandleAndSoapMaking = @"candleandsoapmaking";
static BVContextualInterest* tierTwoHobbiesAndInterestsCardGames = @"cardgames";
static BVContextualInterest* tierTwoHobbiesAndInterestsChess = @"chess";
static BVContextualInterest* tierTwoHobbiesAndInterestsCigars = @"cigars";
static BVContextualInterest* tierTwoHobbiesAndInterestsCollecting = @"collecting";
static BVContextualInterest* tierTwoHobbiesAndInterestsComicBooks = @"comicbooks";
static BVContextualInterest* tierTwoHobbiesAndInterestsDrawingSketching = @"drawingsketching";
static BVContextualInterest* tierTwoHobbiesAndInterestsFreelanceWriting = @"freelancewriting";
static BVContextualInterest* tierTwoHobbiesAndInterestsGenealogy = @"genealogy";
static BVContextualInterest* tierTwoHobbiesAndInterestsGettingPublished = @"gettingpublished";
static BVContextualInterest* tierTwoHobbiesAndInterestsGuitar = @"guitar";
static BVContextualInterest* tierTwoHobbiesAndInterestsHomeRecording = @"homerecording";
static BVContextualInterest* tierTwoHobbiesAndInterestsInvestorsAndPatents = @"investorsandpatents";
static BVContextualInterest* tierTwoHobbiesAndInterestsJewelryMaking = @"jewelrymaking";
static BVContextualInterest* tierTwoHobbiesAndInterestsMagicAndIllusion = @"magicandillusion";
static BVContextualInterest* tierTwoHobbiesAndInterestsNeedlework = @"needlework";
static BVContextualInterest* tierTwoHobbiesAndInterestsPainting = @"painting";
static BVContextualInterest* tierTwoHobbiesAndInterestsPhotography = @"photography";
static BVContextualInterest* tierTwoHobbiesAndInterestsRadio = @"radio";
static BVContextualInterest* tierTwoHobbiesAndInterestsRoleplayingGames = @"roleplayinggames";
static BVContextualInterest* tierTwoHobbiesAndInterestsSciFiAndFantasy = @"scifiandfantasy";
static BVContextualInterest* tierTwoHobbiesAndInterestsScrapbooking = @"scrapbooking";
static BVContextualInterest* tierTwoHobbiesAndInterestsScreenwriting = @"screenwriting";
static BVContextualInterest* tierTwoHobbiesAndInterestsStampsAndCoins = @"stampsandcoins";
static BVContextualInterest* tierTwoHobbiesAndInterestsToys = @"toys";
static BVContextualInterest* tierTwoHobbiesAndInterestsVideoAndComputerGames = @"videoandcomputergames";
static BVContextualInterest* tierTwoHobbiesAndInterestsWoodworking = @"woodworking";

/// Contextual Interests Tier 2: Sporting Goods
static BVContextualInterest* tierTwoSportingGoodsCampingAndHiking = @"campingandhiking";
static BVContextualInterest* tierTwoSportingGoodsExerciseAndFitness = @"exerciseandfitness";
static BVContextualInterest* tierTwoSportingGoodsIndividualSports = @"individualsports";
static BVContextualInterest* tierTwoSportingGoodsTeamSports = @"teamsports";

/// Contextual Interests Tier 2: Education
static BVContextualInterest* tierTwoEducation712Education = @"712education";
static BVContextualInterest* tierTwoEducationAdultEducation = @"adulteducation";
static BVContextualInterest* tierTwoEducationArtHistory = @"arthistory";
static BVContextualInterest* tierTwoEducationCollegeAdministration = @"collegeadministration";
static BVContextualInterest* tierTwoEducationCollegeLife = @"collegelife";
static BVContextualInterest* tierTwoEducationDistanceLearning = @"distancelearning";
static BVContextualInterest* tierTwoEducationEnglishasa2ndLanguage = @"englishasa2ndlanguage";
static BVContextualInterest* tierTwoEducationGraduateSchool = @"graduateschool";
static BVContextualInterest* tierTwoEducationHomeschooling = @"homeschooling";
static BVContextualInterest* tierTwoEducationHomeworkStudyTips = @"homeworkstudytips";
static BVContextualInterest* tierTwoEducationK6Educators = @"k6educators";
static BVContextualInterest* tierTwoEducationLanguageLearning = @"languagelearning";
static BVContextualInterest* tierTwoEducationPrivateSchool = @"privateschool";
static BVContextualInterest* tierTwoEducationSpecialEducation = @"specialeducation";
static BVContextualInterest* tierTwoEducationStudyingBusiness = @"studyingbusiness";

/// Contextual Interests Tier 2: Consumer Electronics
static BVContextualInterest* tierTwoConsumerElectronicsAudio = @"audio";
static BVContextualInterest* tierTwoConsumerElectronicsBatteriesAndPower = @"batteriesandpower";
static BVContextualInterest* tierTwoConsumerElectronicsCableBoxes = @"cableboxes";
static BVContextualInterest* tierTwoConsumerElectronicsCarElectronicsAndGPS = @"carelectronicsandgps";
static BVContextualInterest* tierTwoConsumerElectronicsCellPhoneCases = @"cellphonecases";
static BVContextualInterest* tierTwoConsumerElectronicsCellPhoneChargers = @"cellphonechargers";
static BVContextualInterest* tierTwoConsumerElectronicsCellPhoneHeadsets = @"cellphoneheadsets";
static BVContextualInterest* tierTwoConsumerElectronicsComputerAccessories = @"computeraccessories";
static BVContextualInterest* tierTwoConsumerElectronicsDesktopComputers = @"desktopcomputers";
static BVContextualInterest* tierTwoConsumerElectronicsHeadphones = @"headphones";
static BVContextualInterest* tierTwoConsumerElectronicsHomeNetworkingConnectivity = @"homenetworkingconnectivity";
static BVContextualInterest* tierTwoConsumerElectronicsInternetAndMediaStreamers = @"internetandmediastreamers";
static BVContextualInterest* tierTwoConsumerElectronicsLaptops = @"laptops";
static BVContextualInterest* tierTwoConsumerElectronicsOtherGadgets = @"othergadgets";
static BVContextualInterest* tierTwoConsumerElectronicsPrintersAndScanners = @"printersandscanners";
static BVContextualInterest* tierTwoConsumerElectronicsSoftware = @"software";
static BVContextualInterest* tierTwoConsumerElectronicsTabletAccessories = @"tabletaccessories";
static BVContextualInterest* tierTwoConsumerElectronicsTablets = @"tablets";
static BVContextualInterest* tierTwoConsumerElectronicsTelevisions = @"televisions";
static BVContextualInterest* tierTwoConsumerElectronicsVideoGameConsoles = @"videogameconsoles";
static BVContextualInterest* tierTwoConsumerElectronicsWearableTechnology = @"wearabletechnology";

/// Contextual Interests Tier 2: Real Estate
static BVContextualInterest* tierTwoRealEstateApartments = @"apartments";
static BVContextualInterest* tierTwoRealEstateArchitects = @"architects";
static BVContextualInterest* tierTwoRealEstateBuyingSellingHomes = @"buyingsellinghomes";
static BVContextualInterest* tierTwoRealEstateCommercial = @"commercial";

/// Contextual Interests Tier 2: Style & Fashion
static BVContextualInterest* tierTwoStyleAndFashionAccessories = @"accessories";
static BVContextualInterest* tierTwoStyleAndFashionBeauty = @"beauty2";
static BVContextualInterest* tierTwoStyleAndFashionBodyArt = @"bodyart";
static BVContextualInterest* tierTwoStyleAndFashionClothing = @"clothing";
static BVContextualInterest* tierTwoStyleAndFashionFashion = @"fashion";
static BVContextualInterest* tierTwoStyleAndFashionJewelry = @"jewelry";

