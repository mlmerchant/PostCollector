#   Post Collect 
#   Usage:  ./PostCollector.ps1 -url https://www.reddit.com/path/to/post/
#
#	    Grab from the following sites:
#		https://www.reddit.com/r/AskReddit/
#
param(
    [string]$url,
    [int]$DesiredCharacterCount = 10000000,
    [bool]$GetSelf = $False,
    [bool]$SkipHistory = $True,
    [int]$Lv0_CharCount = 775,
    [int]$Lv0_1_CharCount = 920,
    [int]$Lv1_CharCount = 920,
    [int]$Lv1_1_CharCount = 1080,
    [int]$Lv2_CharCount = 835,
    [int]$Lv2_1_CharCount = 980,
    [int]$Lv3_CharCount = 750,
    [int]$Lv3_1_CharCount = 880,
    [int]$GetCommentLevels = 3,
    [string] $PostHistoryLog = '.\PostHistory.log',
    [string] $SaveFolder = $PSScriptRoot
)

#Set all Char Count to 680 per slide for v1
$global:MaxCharCount = $Lv0_CharCount

#$DesiredCharacterCount = 16000 #18 Minutes
#$DesiredCharacterCount = 18000 #18kb
#$DesiredCharacterCount = 20000 #20kb

function FixCommonMistakes
{
	param([string] $line)

	#Place to clean up garbage formatting
	$line = $line.Trim()
	
	
	# string -replace "this","that" is case insenstive
	$line = $line -replace '  ',' '
	$line = $line -replace '\.\.\.\.','.'
	$line = $line -replace '\.\.\.','.'
	$line = $line -replace '\.\.','.'
	$line = $line -replace '!\.','!'  			
	$line = $line -replace '\?\.','?'  			
	$line = $line -replace ' i ',' I '  		
	$line = $line -replace " cant "," can't " 	
	$line = $line -replace " can't\."," can't."
    $line = $line -replace " dont "," don't "
    $line = $line -replace " dont\."," don't."
    $line = $line -replace " didnt "," didn't " 	
    $line = $line -replace '&amp;',''		
    $line = $line -replace '&gt;',''		
    $line = $line -replace " i've "," I've " 	
	$line = $line -replace '\*',''		
	$line = $line -replace 'fiance','fiancé'
	$line = $line -replace ' pdf ',' PDF '
	$line = $line -replace '^Ofc ','Of course '
	$line = $line -replace '^i ','I '
	$line = $line -replace "^i'll ","I'll "
	$line = $line -replace " i'll "," I'll "
	$line = $line -replace " awhile "," a while "
	$line = $line -replace " wouldnt "," wouldn't "
	$line = $line -replace " doesnt "," doesn't "
	$line = $line -replace " arent "," aren't "
	$line = $line -replace " on going "," ongoing "
	$line = $line -replace " halloween "," Halloween "
	$line = $line -replace " isnt "," isn't "
	$line = $line -replace " recieve "," receive "
	$line = $line -replace "^NEVER ","Never "
	$line = $line -replace '^Evertime ','Every time '
	
	
	# String.replace('this','that') is case sensative
	$line = ($line).replace(' itll ', " it'll ")
	$line = ($line).replace(' EXTREMELY ', " extremely ")
	$line = ($line).replace(' NOT ', " not ")
	$line = ($line).replace(' VERY ', " very ")
	$line = ($line).replace(' youre ', " you're ")
	$line = ($line).replace(' atleast ', " at least ")
	$line = ($line).replace(' alot ', " a lot ")
	$line = ($line).replace(" i'm ", " I'm ")
	$line = ($line).replace(" WAY ", " way ")
	$line = ($line).replace(" LOVE ", " love ")
    $line = ($line).replace(" EVERYTHING ", " everything ")
	$line = ($line).replace(" NOTHING ", " nothing ")
	$line = ($line).replace("#x200B;", "")
	$line = ($line).replace(" WANT ", " want ")
	$line = ($line).replace(" yrs ", " years ")
	$line = ($line).replace(" yr ", " year ")
	$line = ($line).replace(" ALL ", " all ")
	$line = ($line).replace(" realise ", " realize ")
	$line = ($line).replace(" AND ", " and ")
	$line = ($line).replace(" JUST ", " just ")
	$line = ($line).replace(" organised ", " organized ")
	$line = ($line).replace(" honour ", " honor ")
	$line = ($line).replace(" favourite ", " favorite ")
	$line = ($line).replace(" occured ", " occurred ")
	$line = ($line).replace(" ur ", " your ")
	$line = ($line).replace(" bc ", " because ")
    $line = ($line).replace(" NEVER ", " never ")
    $line = ($line).replace(" NEEDED "," needed ")
    $line = ($line).replace(" REALLY "," really ")
    $line = ($line).replace(" WHITE "," white ")
    $line = ($line).replace(" WOULD "," would ")
    $line = ($line).replace(" HEAR "," hear ")
    $line = ($line).replace(" CLEARLY "," clearly ")
    $line = ($line).replace(" SHE "," she ")
    $line = ($line).replace(" PLENTY "," plenty ")
    $line = ($line).replace(" colour "," color ")         
    $line = ($line).replace(" fourty "," forty ")
    $line = ($line).replace(" WOULD,"," would,")
    $line = ($line).replace(" COULD."," could.")
    $line = ($line).replace(" uni "," university ")
    $line = ($line).replace(" MASSIVE "," massive ")
    $line = ($line).replace("lmao","LMAO")
    $line = ($line).replace(" NOT "," not ")
    $line = ($line).replace(" SHE "," she ")
    $line = ($line).replace(" MAN "," man ")
    $line = ($line).replace(" HAVE "," have ")
    $line = ($line).replace(" MY "," my ")
    $line = ($line).replace("DISGUSTING","disgusting")
    $line = ($line).replace(" ANY "," any ")
    $line = ($line).replace(" FUCKS "," fucks ")
    $line = ($line).replace(" UP "," up ")
	$line = ($line).replace("-.-","")
    $line = ($line).replace(" TOO "," too ")
    $line = ($line).replace(" wayyyyy "," way ")
    $line = ($line).replace(" wayyyy "," way ")
    $line = ($line).replace(" wayyy "," way ")
    $line = ($line).replace(" wayy "," way ")
    $line = ($line).replace(" HARD."," hard.")
	$line = ($line).replace(" TO YOU "," to you ")
	$line = ($line).replace(" THAT "," that ")
	$line = ($line).replace("&lt;","")
	$line = ($line).replace(" CRAZY "," crazy ")
	$line = ($line).replace("0/hr","0 an hour")
	$line = ($line).replace("1/hr","1 an hour")
	$line = ($line).replace("2/hr","2 an hour")
	$line = ($line).replace("3/hr","3 an hour")
	$line = ($line).replace("4/hr","4 an hour")
	$line = ($line).replace("5/hr","5 an hour")
	$line = ($line).replace("6/hr","6 an hour")
	$line = ($line).replace("7/hr","7 an hour")
	$line = ($line).replace("8/hr","8 an hour")
	$line = ($line).replace("9/hr","9 an hour")
    $line = ($line).replace(" ANYWHERE "," anywhere ")
    $line = ($line).replace(" ONE "," one ")
    $line = ($line).replace(" TWO "," two ")
    $line = ($line).replace(" THREE "," three ")
    $line = ($line).replace(" FOUR "," four ")
    $line = ($line).replace(" FIVE "," five ")
    $line = ($line).replace(" SIX "," six ")
    $line = ($line).replace(" SEVEN "," seven ")
    $line = ($line).replace(" EIGHT "," eight ")
    $line = ($line).replace(" NINE "," nine ")
    $line = ($line).replace(" TEN "," ten ")
    $line = ($line).replace(" DAYS "," days ")
    $line = ($line).replace(" MONTHS "," months ")
    $line = ($line).replace(" sometime "," some time ")
	$line = ($line).replace(" FEEL "," feel ")
    $line = ($line).replace(" noone "," no one ")
    $line = ($line).replace(" realised "," realized ")
    $line = ($line).replace(" MANY "," many ")
    $line = ($line).replace(" WORSE "," worse ")
    $line = ($line).replace("Wtf?"," WTF?")
    $line = ($line).replace(" tiktok "," TikTok ")
    $line = ($line).replace(" behaviour "," behavior ")
    $line = ($line).replace(" recognised "," recognized ")
    $line = ($line).replace(" realising "," realizing ")
    $line = ($line).replace(" defence "," defense ")
    $line = ($line).replace(" apologise "," apologize ")
    $line = ($line).replace(" ONCE "," once ")
    $line = ($line).replace(" THEY "," they ")
    $line = ($line).replace(" SOMEONE "," someone ")
    $line = ($line).replace(" can not "," cannot ")
    $line = ($line).replace(" ABSOLUTELY "," absolutely ")
	$line = ($line).replace(" wasnt "," wasn't ") 
	$line = ($line).replace(" CONSISTENTLY "," consistently ")
    $line = ($line).replace(" DEMAND "," demand ")
    $line = ($line).replace(" CLEAR "," clear ")
    $line = ($line).replace("wtf?","WTF?")
    $line = ($line).replace(" ANYTHING "," anything ")
    $line = ($line).replace(" .-",".")
    $line = ($line).replace(" AUDACITY "," audacity ")
    $line = ($line).replace(" ESPECIALLY "," especially ")
    $line = ($line).replace(" fbi "," FBI ")
    $line = ($line).replace("highschool","high school")
	$line = ($line).replace(" EVERYONE "," everyone ")
	$line = ($line).replace(" REAL "," real ")
	$line = ($line).replace(" MONTH "," month ")
	$line = ($line).replace(" YEARS "," years ")
	$line = ($line).replace(" CONSTANTLY "," constantly ")
	$line = ($line).replace(" programme "," program ")
	$line = ($line).replace("recognise","recognize")
	$line = ($line).replace("eachother","each other")
	$line = ($line).replace("neighbour","neighbor")
	$line = ($line).replace("unsavoury","unsavory")
	$line = ($line).replace("apologise","apologize")
	$line = ($line).replace("rumour","rumor")
	$line = ($line).replace(" ALWAYS "," always ")
	$line = ($line).replace(" ppl "," people ")
	$line = ($line).replace(" everytime "," every time ")
	$line = ($line).replace(" couldnt "," couldn't ")
	$line = ($line).replace(" realises "," realizes ")
	$line = ($line).replace(" KNEW "," knew ")
	$line = ($line).replace(" PLENTY,"," plenty,")
	$line = ($line).replace(" i'd "," I'd ")
	$line = ($line).replace(" NEED "," need ")
	$line = ($line).replace(" infront "," in front ")
	$line = ($line).replace(" BIGGEST "," biggest ")
	$line = ($line).replace(" nevermind "," never mind ")
	$line = ($line).replace(" actualising "," actualizing ")
	$line = ($line).replace(" organisation "," organization ")
	$line = ($line).replace(" favour "," favor ")
	$line = ($line).replace(" favourite "," favorite ")
	$line = ($line).replace(" i'm "," I'm ")
    $line = ($line).replace(" TRY "," try ")
	$line = ($line).replace(" GREAT "," great ")
	$line = ($line).replace(" FUCKING "," fucking ")
	$line = ($line).replace(" HARD "," hard ")
	$line = ($line).replace(" OPENINGS "," openings ")
    $line = ($line).replace(" bbq "," BBQ ")
    $line = ($line).replace(" rubberband "," rubber band ")
    $line = ($line).replace(" rubberbands "," rubber bands ")
    $line = ($line).replace(" alltogether "," altogether ")
    $line = ($line).replace(" wont "," won't ")
    $line = ($line).replace(" im "," I'm ")
    $line = ($line).replace(" beutiful "," beautiful ")
    $line = ($line).replace(" european "," European ")
    $line = ($line).replace(" american "," American ")
    $line = ($line).replace(" behavioural "," behavioral ")
    $line = ($line).replace(" HUGE "," huge ")
    $line = ($line).replace(" supressing "," suppressing ")
	$line = ($line).replace(" siginifanctly "," significantly ")
	$line = ($line).replace(" moreso "," more so ")
	$line = ($line).replace(" writiing "," writing ")
	$line = ($line).replace("iirc","IIRC")
	$line = ($line).replace(" SHOULD "," should ")
    $line = ($line).replace(" LOVED "," loved ")
    $line = ($line).replace(" HATED "," hated ")
    $line = ($line).replace(" grabed "," grabbed ")
    $line = ($line).replace(" piont "," point ")
    $line = ($line).replace(" BLOCK "," block ")    
    $line = ($line).replace(" i’m "," I'm ") #DON'T EDIT
    $line = ($line).replace(" goverment "," government ")
    $line = ($line).replace(" stabing "," stabbing ")
    $line = ($line).replace(" organise "," organize ")
    $line = ($line).replace(" ocurring "," occurring ")
    $line = ($line).replace(" dimentia "," dementia ")
    $line = ($line).replace(" america "," America ")
    $line = ($line).replace(" africa "," Africa ")
    $line = ($line).replace(" cognisant "," cognizant ")
    $line = ($line).replace(" tshirt "," t-shirt ")
    $line = ($line).replace(" idolised "," idolized ")
    $line = ($line).replace(" youtube "," YouTube ")
    $line = ($line).replace(" styrofoam "," Styrofoam ")
    $line = ($line).replace(" velcro "," Velcro ")
    $line = ($line).replace(" christmas "," Christmas ")
    $line = ($line).replace(" hollywood "," Hollywood ")
    $line = ($line).replace(" russia "," Russia ")
    $line = ($line).replace(" petrie "," Petrie ")    
    $line = ($line).replace(" buttcheeks "," butt cheeks ")
    $line = ($line).replace(" swiss "," Swiss ")
    $line = ($line).replace(" werent "," were'nt ")    
    $line = ($line).replace(" subsidised "," subsidized ")
    $line = ($line).replace(" sexualised "," sexualized ")
    $line = ($line).replace(" coloured "," colored ")
    $line = ($line).replace(" everyday "," every day ")
    $line = ($line).replace(" portland "," Portland ")
    $line = ($line).replace(" oregon "," Oregon ")
    $line = ($line).replace(" BOTH "," both ")
    $line = ($line).replace(" A LOT OF "," a lot of ")
    $line = ($line).replace(" ASSHOLES "," assholes ")
    $line = ($line).replace(" LONG "," long ")
    $line = ($line).replace(" sooo "," so ")
    $line = ($line).replace(" americans "," Americans ")
    $line = ($line).replace(" canadian "," Canadian ")
    $line = ($line).replace(" belive "," believe ")
    $line = ($line).replace(" flavourful "," flavorful ")
    $line = ($line).replace(" flavouring "," flavoring ")
    $line = ($line).replace(" yatch "," yacht ")
    $line = ($line).replace(" africa "," Africa ")
    $line = ($line).replace(" USUALLY "," usually ")
    $line = ($line).replace(" apprently "," apparently ")
    $line = ($line).replace(" loooves "," loves ")
    $line = ($line).replace(" personaly "," personally ")
    $line = ($line).replace(" FILTHY "," filthy ")
    $line = ($line).replace(" flavoured "," flavored ")
    $line = ($line).replace(" flavour "," flavor ")
    $line = ($line).replace(" i "," I ")
    $line = ($line).replace(" incase "," in case ")
    $line = ($line).replace(" chinese "," Chinese ")
    $line = ($line).replace(" labour "," labor ")
    $line = ($line).replace(" italian "," Italian ")
    $line = ($line).replace(" facebook "," Facebook ")
    $line = ($line).replace(" SERIOUS "," serious ")
    $line = ($line).replace(" EVERY "," every ")
    $line = ($line).replace(" coporate "," corporate ")
    $line = ($line).replace("   .",".")
    $line = ($line).replace("  .",".")
    $line = ($line).replace(" .",".")
    $line = ($line).replace(" SEVERLY "," severely ")
    $line = ($line).replace(" SEVERELY ","  severely ")
    $line = ($line).replace(" Spongebob "," SpongeBob ")
    $line = ($line).replace(" humour ","  humor ")
    $line = ($line).replace(" youself "," yourself ")
    $line = ($line).replace(" EXHAUSTED ","  exhausted ")
    $line = ($line).replace("0yr ","0 year ")
    $line = ($line).replace("1yr ","1 year ")
    $line = ($line).replace("2yr ","2 year ")
    $line = ($line).replace("3yr ","3 year ")
    $line = ($line).replace("4yr ","4 year ")
    $line = ($line).replace("5yr ","5 year ")
    $line = ($line).replace("6yr ","6 year ")
    $line = ($line).replace("7yr ","7 year ")
    $line = ($line).replace("8yr ","8 year ")
    $line = ($line).replace("9yr ","9 year ")
    $line = ($line).replace("0yrs ","0 years ")
    $line = ($line).replace("1yrs ","1 years ")
    $line = ($line).replace("2yrs ","2 years ")
    $line = ($line).replace("3yrs ","3 years ")
    $line = ($line).replace("4yrs ","4 years ")
    $line = ($line).replace("5yrs ","5 years ")
    $line = ($line).replace("6yrs ","6 years ")
    $line = ($line).replace("7yrs ","7 years ")
    $line = ($line).replace("8yrs ","8 years ")
    $line = ($line).replace("9yrs ","9 years ")
    $line = ($line).replace(" civilised "," civilized ")
    $line = ($line).replace(" itd "," it'd ")
    $line = ($line).replace(" MUST "," must ")
    $line = ($line).replace(" payed "," paid ")
    $line = ($line).replace(" favours "," favors ")
    $line = ($line).replace(" DOES "," does ")
    $line = ($line).replace(" centre "," center ")
    $line = ($line).replace(" becase "," because ")
    $line = ($line).replace(" hrs "," hours ")
    $line = ($line).replace(" realisation "," realization ")
    $line = ($line).replace(" apparantly "," apparently ")
    $line = ($line).replace(" british "," British ")
    $line = ($line).replace(" english "," English ")
    $line = ($line).replace(" WITH "," with ")
    $line = ($line).replace(" HATE "," hate ")
    $line = ($line).replace(" supress "," suppress ")
    $line = ($line).replace(" LIFEGUARD "," lifeguard ")
    $line = ($line).replace(" genuis "," genius ")
    $line = ($line).replace(" EXTRA "," extra ")
    $line = ($line).replace(" LIFEGUARD "," lifeguard ")
    $line = ($line).replace(" genuis "," genius ")
    $line = ($line).replace(" paypal "," PayPal ")
    $line = ($line).replace(" Paypal "," PayPal ")
    $line = ($line).replace(" shouldnt "," shouldn't ")
    $line = ($line).replace(" CURRENTLY "," currently ")
    $line = ($line).replace(" WISH "," wish ")  
    $line = ($line).replace("!!","!")
    $line = ($line).replace("!!!","!")
    $line = ($line).replace("!!!!","!")
    $line = ($line).replace(" UNDERSTAND "," understand ")
    $line = ($line).replace(" grimey "," grimy ")
    $line = ($line).replace("Yesss","Yes")
    $line = ($line).replace(" hadnt."," hadn't.")
    $line = ($line).replace(" bangladeshi "," Bangladeshi ")
    $line = ($line).replace(" thats "," that's ")  
    $line = ($line).replace(" oooh "," oh ")
    $line = ($line).replace(" existence "," existence ")
    $line = ($line).replace(" catched "," caught ")
    $line = ($line).replace("Dont ","Don't ")  
    $line = ($line).replace(" theres "," there's ")
    $line = ($line).replace("Thats ","That's ")
    $line = ($line).replace("Tbh, ","TBH, ")
    $line = ($line).replace(" favourites "," favorites ")
    $line = ($line).replace(" tho ","though ")
    $line = ($line).replace(" whats "," what's ")
    $line = ($line).replace(" socialise "," socialize ")
    $line = ($line).replace(" SAME "," same ")
    $line = ($line).replace(" EXACT "," exact ")
    $line = ($line).replace(" youve "," you've ")
    $line = ($line).replace(" china "," China ")
    $line = ($line).replace(" EXACTLY "," exactly ")
    $line = ($line).replace(" MIGHT "," might ")
    $line = ($line).replace(" WILL "," will ")
    $line = ($line).replace(" agonising "," agonizing ")
    $line = ($line).replace(" adhd "," ADHD ")
    $line = ($line).replace(" MORE "," more ")
    $line = ($line).replace(" extremly "," extremely ")
    $line = ($line).replace(" fkn "," fucking ")    
    $line = ($line).replace(" reaaaaaly "," realy ")
    $line = ($line).replace(" reaaaaly "," realy ")
    $line = ($line).replace(" reaaaly "," realy ")
    $line = ($line).replace(" reaaly "," realy ")   
    $line = ($line).replace(" waaaaay "," way ")
    $line = ($line).replace(" waaaay "," way ")
    $line = ($line).replace(" waaay "," way ")
    $line = ($line).replace(" waay "," way ")    
    $line = ($line).replace(" omg "," OMG ")
    $line = ($line).replace(" omg "," OMG ")
    $line = ($line).replace(", imo.",", IMO.")    
    $line = ($line).replace(" england "," England ")
    $line = ($line).replace(" OBSESSED "," obsessed ")
    $line = ($line).replace(" OBVIOUSLY "," obviously ")
    $line = ($line).replace(" empathise "," empathize ")
    $line = ($line).replace(" jewellery "," jewelry ")
    $line = ($line).replace(" imo."," IMO.")
    $line = ($line).replace(" DONE "," done ")
    $line = ($line).replace(" DOWN "," down ")
    $line = ($line).replace(" cpr "," CPR ")
    $line = ($line).replace(" monday "," Monday ")
    $line = ($line).replace(" tuesday "," Tuesday ")
    $line = ($line).replace(" wednesday "," Wednesday ")
    $line = ($line).replace(" thursday "," Thursday ")
    $line = ($line).replace(" friday "," Friday ")
    $line = ($line).replace(" saturday "," Saturday ")
    $line = ($line).replace(" sunday "," Sunday ")
    $line = ($line).replace(" january "," January ")
    $line = ($line).replace(" february "," February ")
    $line = ($line).replace(" april "," April ")
    $line = ($line).replace(" june "," June ")
    $line = ($line).replace(" july "," July ")
    $line = ($line).replace(" august "," August ")
    $line = ($line).replace(" september "," September ")
    $line = ($line).replace(" october "," October ")
    $line = ($line).replace(" november "," November ")
    $line = ($line).replace(" december "," December ")
    $line = ($line).replace(" alaskan "," Alaskan ")
    $line = ($line).replace(" SEVERE "," severe ")
    $line = ($line).replace(" y/o "," year old ")
    $line = ($line).replace(" canada "," Canada ")
    $line = ($line).replace(" french "," French ")
    $line = ($line).replace(" EXCEPT "," except ")
    $line = ($line).replace(" planing "," planning ")
    $line = ($line).replace(" vhs "," VHS ")
    $line = ($line).replace(" tvs "," TVs ")
    $line = ($line).replace(" revolutionised "," revolutionized ")
    $line = ($line).replace(" RUINED "," ruined ")
    $line = ($line).replace(" nintendo "," Nintendo ")
    $line = ($line).replace(" wayyyyyyyyyyyyyyyyyyyyy "," way ")
    $line = ($line).replace(" wayyyyyyyyyyyyyyyyyyyy "," way ")  
    $line = ($line).replace(" wayyyyyyyyyyyyyyyyyyy "," way ")
    $line = ($line).replace(" wayyyyyyyyyyyyyyyyyy "," way ")
    $line = ($line).replace(" wayyyyyyyyyyyyyyyyy "," way ")
    $line = ($line).replace(" wayyyyyyyyyyyyyyyy "," way ")
    $line = ($line).replace(" wayyyyyyyyyyyyyyy "," way ")
    $line = ($line).replace(" wayyyyyyyyyyyyyy "," way ")
    $line = ($line).replace(" wayyyyyyyyyyyyy "," way ")
    $line = ($line).replace(" wayyyyyyyyyyyy "," way ")
    $line = ($line).replace(" wayyyyyyyyyyy "," way ")
    $line = ($line).replace(" wayyyyyyyyyy "," way ")
    $line = ($line).replace(" wayyyyyyyyy "," Way ")          
    $line = ($line).replace(" wayyyyyyy "," way ")   
    $line = ($line).replace(" wayyyyyy "," Way ")   
    $line = ($line).replace(" wayyyyy "," way ")
    $line = ($line).replace(" wayyy "," way ")
    $line = ($line).replace(" wayy "," way ")
    $line = ($line).replace(" pokemon "," Pokémon ")
    $line = ($line).replace(" Pokemon "," Pokémon ")
    $line = ($line).replace("0yo ","0 year old ")
    $line = ($line).replace("1yo ","1 year old ")
    $line = ($line).replace("2yo ","2 year old ")
    $line = ($line).replace("3yo ","3 year old ")
    $line = ($line).replace("4yo ","4 year old ")
    $line = ($line).replace("5yo ","5 year old ")
    $line = ($line).replace("6yo ","6 year old ")
    $line = ($line).replace("7yo ","7 year old ")
    $line = ($line).replace("8yo ","8 year old ")
    $line = ($line).replace("9yo ","9 year old ")
    $line = ($line).replace(" controling "," controlling ")
    $line = ($line).replace(" THINGS "," things ")
    $line = ($line).replace(" CERTAINLY "," certainly ")
    $line = ($line).replace(" sturdyness "," sturdiness ")
    $line = ($line).replace(" truely "," truly ")
    $line = ($line).replace("???","?")
    $line = ($line).replace(" loooooooooong "," very long ")
    $line = ($line).replace(" looooooooong "," very long ")
    $line = ($line).replace(" loooooooong "," very long ")
    $line = ($line).replace(" looooooong "," very long ")
    $line = ($line).replace(" loooooong "," very long ")
    $line = ($line).replace(" looooong "," very long ")    
    $line = ($line).replace(" loooong "," very long ")    
    $line = ($line).replace(" looong "," very long ")    
    $line = ($line).replace(" BRUTALLY "," brutally ")
    $line = ($line).replace(" armour "," armor ")
    $line = ($line).replace(" colours "," colors ")
    $line = ($line).replace(" armour "," armor ")
    $line = ($line).replace(" analysing "," analyzing ")
    $line = ($line).replace(" HOURS "," hours ")
    $line = ($line).replace(" tbh."," TBH.")
    $line = ($line).replace(" fk "," fuck ")
    $line = ($line).replace(" normalises "," normalizes ")
    $line = ($line).replace(" Tiktok "," TikTok ")
    $line = ($line).replace(" tiktok "," TikTok ")
    $line = ($line).replace(" ukrain "," Ukrain ")
    $line = ($line).replace(" antartic "," Antartic ")       
    $line = ($line).replace(" soooooooooooooooooo "," so very ")
    $line = ($line).replace(" sooooooooooooooooo "," so very ")
    $line = ($line).replace(" soooooooooooooooo "," so very ")          
    $line = ($line).replace(" sooooooooooooooo "," so very ")
    $line = ($line).replace(" soooooooooooooo "," so very ")
    $line = ($line).replace(" sooooooooooooo "," so very ")
    $line = ($line).replace(" soooooooooooo "," so very ")
    $line = ($line).replace(" sooooooooooo "," so very ")
    $line = ($line).replace(" soooooooooo "," so very ")    
    $line = ($line).replace(" sooooooooo "," so very ")
    $line = ($line).replace(" soooooooo "," so very ")
    $line = ($line).replace(" sooooooo "," so very ")
    $line = ($line).replace(" soooooo "," so very ") 
    $line = ($line).replace(" sooooo "," so very ")
    $line = ($line).replace(" soooo "," so very ")
    $line = ($line).replace(" sooo "," so very ")     
    $line = ($line).replace(" suuuuuuuuuuuuuuuuuuuuuper "," super ")    
    $line = ($line).replace(" suuuuuuuuuuuuuuuuuuuuper "," super ")
    $line = ($line).replace(" suuuuuuuuuuuuuuuuuuuper "," super ")
    $line = ($line).replace(" suuuuuuuuuuuuuuuuuuper "," super ")
    $line = ($line).replace(" suuuuuuuuuuuuuuuuuper "," super ")
    $line = ($line).replace(" suuuuuuuuuuuuuuuuper "," super ")
    $line = ($line).replace(" suuuuuuuuuuuuuuuper "," super ")
    $line = ($line).replace(" suuuuuuuuuuuuuuper "," super ")
    $line = ($line).replace(" suuuuuuuuuuuuuper "," super ")
    $line = ($line).replace(" suuuuuuuuuuuuper "," super ")
    $line = ($line).replace(" suuuuuuuuuuper "," super ") 
    $line = ($line).replace(" suuuuuuuuuper "," super ") 
    $line = ($line).replace(" suuuuuuuuper "," super ")     
    $line = ($line).replace(" suuuuuuuper "," super ")     
    $line = ($line).replace(" suuuuuuper "," super ")     
    $line = ($line).replace(" suuuuuper "," super ")     
    $line = ($line).replace(" suuuper "," super ")         
    $line = ($line).replace(" suuper "," super ") 
    $line = ($line).replace(" licence "," license ")
    $line = ($line).replace(" specialised "," specialized ")
    $line = ($line).replace(" trama "," trauma ")      
    $line = ($line).replace("Yuuuuuuuuuuuuuuuuuuuuuup.","Yup.")
    $line = ($line).replace("Yuuuuuuuuuuuuuuuuuuuuup.","Yup.")
    $line = ($line).replace("Yuuuuuuuuuuuuuuuuuuuup.","Yup.")
    $line = ($line).replace("Yuuuuuuuuuuuuuuuuuuup.","Yup.")
    $line = ($line).replace("Yuuuuuuuuuuuuuuuuuup.","Yup.")
    $line = ($line).replace("Yuuuuuuuuuuuuuuuuup.","Yup.")
    $line = ($line).replace("Yuuuuuuuuuuuuuuuup.","Yup.")
    $line = ($line).replace("Yuuuuuuuuuuuuuuup.","Yup.")
    $line = ($line).replace("Yuuuuuuuuuuuuuup.","Yup.")
    $line = ($line).replace("Yuuuuuuuuuuuuup.","Yup.")
    $line = ($line).replace("Yuuuuuuuuuuuup.","Yup.")
    $line = ($line).replace("Yuuuuuuuuuuup.","Yup.")
    $line = ($line).replace("Yuuuuuuuuuup.","Yup.")
    $line = ($line).replace("Yuuuuuuuuup.","Yup.")
    $line = ($line).replace("Yuuuuuuuup.","Yup.")
    $line = ($line).replace("Yuuuuuuup.","Yup.")
    $line = ($line).replace("Yuuuuuup.","Yup.")
    $line = ($line).replace("Yuuuuup.","Yup.")
    $line = ($line).replace("Yuuuup.","Yup.")
    $line = ($line).replace("Yuuup.","Yup.")
    $line = ($line).replace("Yuup.","Yup.")    
    $line = ($line).replace("fuuuuuuuuuuuuck","fuck")
    $line = ($line).replace("fuuuuuuuuuuuck","fuck")
    $line = ($line).replace("fuuuuuuuuuuck","fuck")
    $line = ($line).replace("fuuuuuuuuuck","fuck")
    $line = ($line).replace("fuuuuuuuuck","fuck")
    $line = ($line).replace("fuuuuuuuck","fuck")
    $line = ($line).replace("fuuuuuuck","fuck")
    $line = ($line).replace("fuuuuuck","fuck")
    $line = ($line).replace("fuuuuck","fuck")
    $line = ($line).replace("fuuuck","fuck")    
    $line = ($line).replace(" dutch "," Dutch ")
    $line = ($line).replace(" enamled "," enameled ")
    $line = ($line).replace(" BAIL "," bail ")
    $line = ($line).replace(" TON "," ton ")
    $line = ($line).replace(" hawaiin "," Hawaiin ")   
    $line = ($line).replace("Noooooooooooooobody","Nobody")
    $line = ($line).replace("Nooooooooooooobody","Nobody")
    $line = ($line).replace("Noooooooooooobody","Nobody")
    $line = ($line).replace("Nooooooooooobody","Nobody")
    $line = ($line).replace("Noooooooooobody","Nobody")
    $line = ($line).replace("Nooooooooobody","Nobody")
    $line = ($line).replace("Noooooooobody","Nobody")
    $line = ($line).replace("Nooooooobody","Nobody")
    $line = ($line).replace("Noooooobody","Nobody")
    $line = ($line).replace("Nooooobody","Nobody")
    $line = ($line).replace("Noooobody","Nobody")
    $line = ($line).replace("Nooobody","Nobody")
    $line = ($line).replace(" tbh,"," TBH,")
    $line = ($line).replace(" theyve "," they've ")
    $line = ($line).replace(" adhd."," ADHD.")
    $line = ($line).replace(" COMFORTABLE "," comfortable ")
    $line = ($line).replace(" capitalised "," capitalized ")    
    $line = ($line).replace(" ALSO "," also ")
    $line = ($line).replace(" THREATENDED "," threatened ")
    $line = ($line).replace(" sleasiest "," sleaziest ")
    $line = ($line).replace(" dna "," DNA ")
    $line = ($line).replace(" memorise "," memorize ")
    $line = ($line).replace(" texas "," Texas ")
    $line = ($line).replace(" Playstation "," PlayStation ")
    $line = ($line).replace(" playstation "," PlayStation ")
    $line = ($line).replace(" digitised "," digitized ")
    $line = ($line).replace(" walmart "," Walmart ")
    $line = ($line).replace(" programme."," program.")
    $line = ($line).replace(" prioritise "," prioritize ")
    $line = ($line).replace(" favourtisim "," favoritism ")
    $line = ($line).replace(" hawaii "," Hawaii ")
    $line = ($line).replace(" prioritised "," prioritized ")
    $line = ($line).replace(" pepsi "," Pepsi ")  
    $line = ($line).replace(" internalise "," internalize ")
    $line = ($line).replace(" MANY "," many ")   
    $line = ($line).replace(" analyse "," analyze ")
    $line = ($line).replace(" ipad "," iPad ")
    $line = ($line).replace(" macbook "," MacBook ")
    $line = ($line).replace(" Macbook "," MacBook ")
    $line = ($line).replace(" japan "," Japan ")
    $line = ($line).replace(" HOT "," hot ")
    $line = ($line).replace(" adblock "," AdBlock ")
    $line = ($line).replace(" poeple "," people ")
    $line = ($line).replace(" thier "," their ")
    $line = ($line).replace(" ONLY "," only ")
    $line = ($line).replace(" Youtube "," YouTube ")
    $line = ($line).replace(" organising "," organizing ")
    $line = ($line).replace(" embarassed "," embarrassed ")
    $line = ($line).replace(" sweden "," Sweden ")
    $line = ($line).replace(" organisations "," organizations ")
    $line = ($line).replace(" BEST "," best ")
    $line = ($line).replace(" christian "," Christian ")
    $line = ($line).replace(" christ "," Christ ")
    $line = ($line).replace(" honours "," honors ")
    $line = ($line).replace(" HIGHLY "," highly ")
    $line = ($line).replace(" WANTED "," wanted ")    
    $line = ($line).replace(" WIDE "," wide ")
    $line = ($line).replace(" emphasises "," emphasizes ")
    $line = ($line).replace(" judgemental "," judgmental ")
    $line = ($line).replace(" criminalise "," criminalize ")
    $line = ($line).replace(" FAR "," far ")
    $line = ($line).replace(" rationalise "," rationalize ")
    $line = ($line).replace(" SUPER "," super ")
    $line = ($line).replace(" instagram "," Instagram ")        
    $line = ($line).replace(" incentivising "," incentivizing ")
    $line = ($line).replace(" flimsyness "," fliminess ")
    $line = ($line).replace(" ukraine "," Ukraine ")
    $line = ($line).replace(" OBSESSIVE "," obsessive ")
    $line = ($line).replace(" NEEDS "," needs ")
    $line = ($line).replace(" ENTIRE "," entire ")
    $line = ($line).replace(" scrutinising "," scrutinizing ")
    $line = ($line).replace(" greatful "," grateful ")
    $line = ($line).replace(" standardised "," standardized ")
    $line = ($line).replace(" capitalise "," capitalize ")
    $line = ($line).replace(" THE TIME "," the time ")
    $line = ($line).replace(" FARMING "," farming ")
    $line = ($line).replace(" TOLD "," told ")
    $line = ($line).replace(" MOST "," most ")
    $line = ($line).replace(" traumatising "," traumatizing ")
    $line = ($line).replace(" houston "," Houston ")
    $line = ($line).replace(" theyre "," they're ")
    $line = ($line).replace(" STAND "," stand ")
    $line = ($line).replace(" waaaaaaaaaaaaaaaaaaaaay "," way ")
    $line = ($line).replace(" waaaaaaaaaaaaaaaaaaaay "," way ")
    $line = ($line).replace(" waaaaaaaaaaaaaaaaaaay "," way ")
    $line = ($line).replace(" waaaaaaaaaaaaaaaaaay "," way ")
    $line = ($line).replace(" waaaaaaaaaaaaaaaaay "," way ")
    $line = ($line).replace(" waaaaaaaaaaaaaaaay "," way ")
    $line = ($line).replace(" waaaaaaaaaaaaaaay "," way ")
    $line = ($line).replace(" waaaaaaaaaaaaaay "," way ")
    $line = ($line).replace(" waaaaaaaaaaaaay "," way ")
    $line = ($line).replace(" waaaaaaaaaaaay "," way ")
    $line = ($line).replace(" waaaaaaaaaaay "," way ")
    $line = ($line).replace(" waaaaaaaaaay "," way ")
    $line = ($line).replace(" waaaaaaaaay "," way ")
    $line = ($line).replace(" waaaaaaaay "," way ")
    $line = ($line).replace(" waaaaaaay "," way ")
    $line = ($line).replace(" waaaaaay "," way ")
    $line = ($line).replace(" waaaaay "," way ")
    $line = ($line).replace(" waaaay "," way ")
    $line = ($line).replace(" waaay "," way ")
    $line = ($line).replace(" italy "," Italy ")
    $line = ($line).replace(" ive "," I've ")
    $line = ($line).replace(" immedately "," immediately ")
    $line = ($line).replace(" orlando "," Orlando ")
    $line = ($line).replace(" comepletely "," completely ")
    $line = ($line).replace(" neighboor "," neighbor ")
    $line = ($line).replace(" embarrasment "," embarrassment ")
    $line = ($line).replace(" ireland "," Ireland ")
    $line = ($line).replace(" DON'T "," don't ")
    $line = ($line).replace(" latinos "," Latinos ")
    $line = ($line).replace(" latino "," Latino ")
    $line = ($line).replace(" organisational "," organizational ")
    $line = ($line).replace(" nazi "," Nazi ")
    $line = ($line).replace(" abt "," about ")
    $line = ($line).replace(" riiiiiiiiiiiiiiiiiiiight "," right ")
    $line = ($line).replace(" riiiiiiiiiiiiiiiiiiight "," right ")
    $line = ($line).replace(" riiiiiiiiiiiiiiiiiight "," right ")
    $line = ($line).replace(" riiiiiiiiiiiiiiiiight "," right ")
    $line = ($line).replace(" riiiiiiiiiiiiiiiight "," right ")
    $line = ($line).replace(" riiiiiiiiiiiiiiight "," right ")
    $line = ($line).replace(" riiiiiiiiiiiiiight "," right ")
    $line = ($line).replace(" riiiiiiiiiiiiight "," right ")
    $line = ($line).replace(" riiiiiiiiiiiight "," right ")
    $line = ($line).replace(" riiiiiiiiiiight "," right ")
    $line = ($line).replace(" riiiiiiiiiight "," right ")
    $line = ($line).replace(" riiiiiiiight "," right ")
    $line = ($line).replace(" riiiiiiight "," right ")
    $line = ($line).replace(" riiiiiight "," right ")
    $line = ($line).replace(" riiiiight "," right ")
    $line = ($line).replace(" riiiight "," right ")
    $line = ($line).replace(" riiight "," right ")
    $line = ($line).replace(" riight "," right ")
    $line = ($line).replace(" explaned "," explained ")
    $line = ($line).replace(" LOT "," lot ")
    $line = ($line).replace(" FINALLY "," finally ")
    $line = ($line).replace(" SUCH "," such ")
    $line = ($line).replace(" DEFINITELY "," definitely ")
    $line = ($line).replace(" THIS "," this ")
    $line = ($line).replace(" normalise "," normalize ")
    $line = ($line).replace(" MEANT "," meant ")
    $line = ($line).replace(" 24-hr "," 24 hour ")
    $line = ($line).replace(" MOMENT "," moment ")
    $line = ($line).replace(" fibre "," fiber ")
    $line = ($line).replace(" EVERYONE "," everyone ")
    $line = ($line).replace(" COMPLETELY "," completely ")
    $line = ($line).replace(" TERRIBLE "," terrible ")
    $line = ($line).replace(" SOMETHING "," something ")
    $line = ($line).replace(" buddhism "," Buddhism ")
    $line = ($line).replace(" fedex "," FedEx ")
    $line = ($line).replace(" INTO "," into ")
    $line = ($line).replace(" BUT "," but ")
    $line = ($line).replace(" ptsd "," PTSD ")
    $line = ($line).replace(" and and "," and ")
    $line = ($line).replace(" the the "," the ")
    $line = ($line).replace(" recieved "," received ")
    $line = ($line).replace(" LOUD "," loud ")
    $line = ($line).replace(" POUNDING "," pounding ")
    $line = ($line).replace(" KILL "," kill ")
    $line = ($line).replace(" MURDERED "," murdered ")
    $line = ($line).replace(" uv "," UV ")
    $line = ($line).replace(" USED "," used ")
    $line = ($line).replace(" boundry "," boundary ")
    $line = ($line).replace(" YOUR "," your ")
    $line = ($line).replace(" havent "," haven't ")
    $line = ($line).replace(" couldve "," could've ")
    $line = ($line).replace(" MILLION "," million ")
    $line = ($line).replace(" PEOPLE "," people ")
    $line = ($line).replace(" symbolise "," symbolize ")
    $line = ($line).replace(" cruelity "," cruelty ")
    $line = ($line).replace(" german "," German ")
    $line = ($line).replace(" germany "," Germany ")
    $line = ($line).replace(" latin "," Latin ")
    $line = ($line).replace(" vp "," VP ")
    $line = ($line).replace(" zen "," Zen ")
    $line = ($line).replace(" SCREAMS "," screams ")
    $line = ($line).replace(" DAY "," day ")
    $line = ($line).replace(" with with "," with ")
    $line = ($line).replace(" metres "," meters ")
    $line = ($line).replace(" traumatised "," tramatized ")
    $line = ($line).replace(" urself "," yourself ")
    $line = ($line).replace(" monitisation "," monitization ")
    $line = ($line).replace(" was was "," was ")
    $line = ($line).replace(" fcked "," fucked ")
    $line = ($line).replace(" hasnt "," hasn't ")
    $line = ($line).replace(" japanese "," Japanese ")
    $line = ($line).replace(" tokyo "," Tokyo ")
    $line = ($line).replace(" tf "," the fuck ")
    $line = ($line).replace(" jew "," Jew ")
    $line = ($line).replace(" thailand "," Thailand ")
    $line = ($line).replace(" spanish "," Spanish ")
    $line = ($line).replace(" WAS "," was ")
    $line = ($line).replace(" ABLE "," able ")
    $line = ($line).replace(" maintence "," maintenance ")
    $line = ($line).replace(" THING "," thing ")
    $line = ($line).replace(" doesnt "," doesn't ")
    $line = ($line).replace(" venmo "," Venmo ")
    $line = ($line).replace(" HER "," her ")
    $line = ($line).replace(" YOU "," you ")
    $line = ($line).replace(" you you "," you ")
    $line = ($line).replace(" LOOK "," look ")
    $line = ($line).replace(" hadnt "," hadn't ")
    $line = ($line).replace(" at at "," at ")
    $line = ($line).replace(" EVER "," ever ")
    $line = ($line).replace(" sterilised "," sterilized ")
    $line = ($line).replace(" INCREDIBLE "," incredible ")
    $line = ($line).replace(" LARGE "," large ") 
    $line = ($line).replace(" GIGANTIC "," gigantic ")
    $line = ($line).replace(" WILDLY "," wildly ") 
    $line = ($line).replace(" STILL "," still ")
    $line = ($line).replace(" WORST "," worst ") 
    $line = ($line).replace(" GOLD "," gold ")
    $line = ($line).replace(" shouldve "," should've ") 
    $line = ($line).replace(" HIM "," him ")
    $line = ($line).replace(" THIER "," their ") 
    $line = ($line).replace(" BEFORE "," before ")
    $line = ($line).replace(" AT LEAST "," at least ")
    $line = ($line).replace(" EVERYBODY "," everybody ") 
    $line = ($line).replace(" SHOCKING "," shocking ")
    $line = ($line).replace(" memorising "," memorizing ")
    $line = ($line).replace(" SPRINTED "," sprinted ")
    $line = ($line).replace(" MUCH "," much ") 
    $line = ($line).replace(" PROVE "," prove ")
    $line = ($line).replace(" LEAST "," least ")
    $line = ($line).replace(" tyres "," tires ") 
    $line = ($line).replace(" HOW "," how ")
    $line = ($line).replace(" summarised "," summarized ")
    $line = ($line).replace(" nvm "," nevermind ")
    $line = ($line).replace(" theyll "," they'll ")
    $line = ($line).replace(" criticising "," criticizing ")
    $line = ($line).replace(" NOBODY "," nobody ")
    $line = ($line).replace(" EVERYWHERE "," everywhere ")
    $line = ($line).replace(" OWING "," owing ")
    $line = ($line).replace(" WANTING "," wanting ")
    $line = ($line).replace(" wtf "," WTF ")
    $line = ($line).replace(" swedish "," Swedish ")
    $line = ($line).replace(" MILLIONS "," millions ")
    $line = ($line).replace(" jew "," Jew ")
    $line = ($line).replace(" jewish "," Jewish ")
    $line = ($line).replace(" ANYTHING "," anything ")
    $line = ($line).replace(" PLEASE "," please ")
    $line = ($line).replace(" REALISTICALLY "," realistically ")
    $line = ($line).replace(" WON'T "," won't ")
    $line = ($line).replace(" RAISE "," raise ") 
    $line = ($line).replace(" ZERO "," zero ")
    $line = ($line).replace(" organises "," organizes ")
    $line = ($line).replace(" modernising "," modernizing ")
    $line = ($line).replace(" HILARIOUSLY "," hilariously ")
    $line = ($line).replace(" FURIOUS "," furious ")
    $line = ($line).replace(" SCREAMED "," screamed ")
    $line = ($line).replace(" REFUND "," refund ")
    $line = ($line).replace(" islamic "," Islamic ")
    $line = ($line).replace(" maximises "," maximizes ")
    $line = ($line).replace(" greeks "," Greeks ")
    $line = ($line).replace(" horriffic "," horrific ")
    $line = ($line).replace(" ALLOWING "," allowing ")
    $line = ($line).replace(" CAN'T "," can't ")
    $line = ($line).replace(" criticised "," criticized ")
    $line = ($line).replace(" OTHER "," other ")
    $line = ($line).replace(" KNOW "," know ")
    $line = ($line).replace(" FREE "," free ")
    $line = ($line).replace(" GREATLY "," greatly ")
    $line = ($line).replace(" WRONG "," wrong ")
    $line = ($line).replace(" MINUTES "," minutes ")
    $line = ($line).replace(" asian "," Asian ")
    $line = ($line).replace(" PISSED "," pissed ")
    $line = ($line).replace(" WHEN "," when ")
    $line = ($line).replace(" asia "," Asia ")
    $line = ($line).replace(" i've "," I've ")
    $line = ($line).replace(" egypt "," Egypt ")
    $line = ($line).replace(" i'd "," I'd ")
    $line = ($line).replace(" obssessed "," obsessed ")  
    $line = ($line).replace(" minimise "," minimize ")   
    $line = ($line).replace(" COMMUNICATE "," communicate ")  
    $line = ($line).replace(" apologising "," apologizing ") 
    $line = ($line).replace(" adderall "," Adderall ")  
    $line = ($line).replace(" suprised "," surprised ")   
    $line = ($line).replace(" ACTUALLY "," actually ") 
    $line = ($line).replace(" GOOD PERSON "," good person ") 
    $line = ($line).replace(" idolise "," idolize ")  
    $line = ($line).replace(" RARELY "," rarely ")      
    $line = ($line).replace(" untill "," until ")  
    $line = ($line).replace(" vomitting "," vomiting ")  
    $line = ($line).replace(" basicly "," basically ")  
    $line = ($line).replace(" tasmanian "," Tasmanian ")  
    $line = ($line).replace(" dieing "," dying ")
    $line = ($line).replace(" litres "," liters ")
    $line = ($line).replace(" characterise "," characterize ") 
    $line = ($line).replace(" ENTIRELY "," entirely ") 
    $line = ($line).replace(" chicago "," Chicago ") 
    $line = ($line).replace(" michigan "," Michigan ")    
    $line = ($line).replace(" THOROUGHLY "," thoroughly ")
    $line = ($line).replace(" restaruants "," restaurants ")
    $line = ($line).replace(" recognisable "," recognizable ")   
    $line = ($line).replace(" wilfully "," willfully ")
    $line = ($line).replace(" HAPPILY "," happily ")
    $line = ($line).replace(" LITERALLY "," literally ")
    $line = ($line).replace(" WHERE "," where ")
    $line = ($line).replace(" IMMEDIATELY "," immediately ")
    $line = ($line).replace(" anoying "," annoying ")
    $line = ($line).replace(" FREQUENTLY "," frequently ")
    $line = ($line).replace(" EXPAND "," expand ")
    $line = ($line).replace(" nazis "," Nazis ")
    $line = ($line).replace(" tyranical "," tyrannical ")
    $line = ($line).replace(" normalised "," normalized ")
    $line = ($line).replace(" commercialisation "," commercialization ")
    $line = ($line).replace(" MAYBE "," maybe ")
    $line = ($line).replace(" Indian "," Indian ")
    $line = ($line).replace(" irish "," Irish ")
    $line = ($line).replace(" seperate "," separate ")
    $line = ($line).replace(" ASK "," ask ")
    $line = ($line).replace(" brazil "," Brazil ")
    $line = ($line).replace(" AFTER "," after ")
    $line = ($line).replace(" ENOUGH "," enough ")
    $line = ($line).replace(" HORRIFIC "," horrific ")
    $line = ($line).replace(" THEM "," them ")
    $line = ($line).replace(" EVERYDAY "," everyday ")
    $line = ($line).replace(" FAVORITE "," favorite ")
    $line = ($line).replace(" spain "," Spain ")
    $line = ($line).replace(" SMOKING "," smoking ")
    $line = ($line).replace(" TAKING "," taking ")
    $line = ($line).replace(" WHAT "," what ")
    $line = ($line).replace(" DEMANDING "," demanding ")
    $line = ($line).replace(" stoped "," stopped ")
    $line = ($line).replace(" SWEAR "," swear ")
    $line = ($line).replace(" INSIDE "," inside ")
    $line = ($line).replace(" timezones "," time zones ")
    $line = ($line).replace(" REFUSE "," refuse ")
    $line = ($line).replace(" LIKE "," like ")
    $line = ($line).replace(" THICK "," thick ")
    $line = ($line).replace(" RUINS "," ruins ")
    $line = ($line).replace(" FASTER "," faster ")
    $line = ($line).replace(" DRAMATICALLY "," dramatically ")
    $line = ($line).replace(" theyd "," they'd ")
    $line = ($line).replace(" OVERLY "," overly ")
    $line = ($line).replace(" OVERALL "," overall ")
    $line = ($line).replace(" DECLINE "," decline ")
    $line = ($line).replace(" BAD "," bad ")
    $line = ($line).replace(" akward "," awkward ")
    $line = ($line).replace(" SOME "," some ")
    $line = ($line).replace(" ENTITLED "," entitled ")
    $line = ($line).replace(" FIRST "," first ")
    $line = ($line).replace(" SLIGHTLY "," slightly ")
    $line = ($line).replace(" THEN "," then ")
    $line = ($line).replace(" REMEMBER "," remember ")
    $line = ($line).replace(" DIFFERENT "," different ")
    $line = ($line).replace(" CANNOT "," cannot ")
    $line = ($line).replace(" HOWEVER "," however ")
    $line = ($line).replace(" LIKING "," liking ")
    $line = ($line).replace(" acusing "," accusing ")
    $line = ($line).replace(" EVENING "," evening ")
    $line = ($line).replace(" REPLACE "," replace ")
    $line = ($line).replace(" REPAIR "," repair ")
    $line = ($line).replace(" definitly "," definitely ")
    $line = ($line).replace(" successfull "," successful ")
    $line = ($line).replace(" i'll "," I'll ")
    $line = ($line).replace(" balkin "," Balkin ")
    $line = ($line).replace(" SUCK "," suck ")
    $line = ($line).replace(" tetris "," Tetris ")
    $line = ($line).replace(" greek "," Greek ")
    $line = ($line).replace(" turks "," Turks ")
    $line = ($line).replace(" powerball "," Powerball ")
    $line = ($line).replace(" CORRECTLY "," correctly ")
    $line = ($line).replace(" MAJORITY "," majority ")
    $line = ($line).replace(" WITHOUT "," without ")
    $line = ($line).replace(" PERFECT "," perfect ")
    $line = ($line).replace(" SCHOOL "," school ")
    $line = ($line).replace(" ADAMANT "," adamant ")
    $line = ($line).replace(" utilise "," utilize ")
    $line = ($line).replace(" MADE "," made ")
    $line = ($line).replace(" txted "," texted ")
    $line = ($line).replace(" misogeny "," misogyny ")
    $line = ($line).replace(" ostracised "," ostracized ")
    $line = ($line).replace(" fuelling "," fueling ")
    $line = ($line).replace(" fulled "," fuled ")
    $line = ($line).replace(" SHOCKED "," shocked ")
    $line = ($line).replace(" vegas "," Vegas ")
    $line = ($line).replace(" monetised "," monetized ")
    $line = ($line).replace(" wouldve "," would've ")
    $line = ($line).replace(" i've "," I've ")
    $line = ($line).replace(" korean "," Korean ")
    $line = ($line).replace(" LOATHE "," loathe ")
    $line = ($line).replace(" BUNCH "," bunch ")
    $line = ($line).replace(" KEEPING "," keeping ")
    $line = ($line).replace(" OUTRAGE "," outrage ")
    $line = ($line).replace(" RAN "," ran ")
    $line = ($line).replace(" TODAY "," today ")
    $line = ($line).replace(" YEAR "," year ")
    $line = ($line).replace(" WHY "," why ")
    $line = ($line).replace(" i'll "," I'll ")
    $line = ($line).replace(" successs "," success ")
    $line = ($line).replace(" succes "," success ")
    $line = ($line).replace(" rationaly "," rationally ")
    $line = ($line).replace(" categorise "," categorize ")
    $line = ($line).replace(" does't "," doesn't ")
    $line = ($line).replace(" RIGHT "," right ")
    $line = ($line).replace(" AWAY "," away ")
    $line = ($line).replace(" LET ME "," let me ")
    $line = ($line).replace(" metre "," meter ")
    $line = ($line).replace(" buffons "," buffoons ")
    $line = ($line).replace(" SEEING "," seeing ")
    $line = ($line).replace(" behaviours "," behaviors ")
    $line = ($line).replace(" interrests "," interests ")
    $line = ($line).replace(" altough "," although ")
    $line = ($line).replace(" awkard "," awkward ")
    $line = ($line).replace(" despenser "," dispenser ")
    $line = ($line).replace(" tumour "," tumor ")
    $line = ($line).replace(" similiar "," similar ")
    $line = ($line).replace(" TRULY "," truly ")
    $line = ($line).replace(" MANDATORY "," mandatory ")
    $line = ($line).replace(" basicallly "," basically ")
    $line = ($line).replace(" REALISTIC "," realistic ")
    $line = ($line).replace(" lbs "," lbs. ")
    $line = ($line).replace(" comitting "," committing ")
    $line = ($line).replace(" NEW "," new ")
    $line = ($line).replace(" odour "," odor ")
    $line = ($line).replace(" deogatory "," derogatory ")
    $line = ($line).replace(" propoganda "," propaganda ")
    $line = ($line).replace(" bestfriend "," best friend ")
    $line = ($line).replace(" bestfriends "," best friends ")
    $line = ($line).replace(" dependant "," dependent ")
    $line = ($line).replace(" sexualise "," sexualize ")
    $line = ($line).replace(" LAYERS "," layers ")
    $line = ($line).replace(" usless "," useless ")
    $line = ($line).replace(" qr "," QR ")
    $line = ($line).replace(" vietnamese "," Vietnamese ")
    $line = ($line).replace(" tumblr "," Tumblr ")
    $line = ($line).replace(" skintone "," skin tone ")
    $line = ($line).replace(" WHOLE "," whole ")
    $line = ($line).replace(" OVER "," over ")
    $line = ($line).replace(" 3d "," 3D ")
    $line = ($line).replace(" EXTREME "," extreme ")
    $line = ($line).replace(" THINK "," think ")
    $line = ($line).replace(" FACT "," fact ")
    $line = ($line).replace(" INSIST "," insist ")
    $line = ($line).replace(" ROUND "," round ")
    $line = ($line).replace(" effacy "," efficacy ")
    $line = ($line).replace(" visualisation "," visualization ")
    $line = ($line).replace(" visualise "," visualize ")
    $line = ($line).replace(" ALONE "," alone ")
    $line = ($line).replace(" COULD "," could ")
    $line = ($line).replace(" switzerland "," Switzerland ")
    $line = ($line).replace(" filipino "," Filipino ")
    $line = ($line).replace(" europe "," Europe ")
    $line = ($line).replace(" , ",", ")
    $line = ($line).replace(" SUPPOSED "," supposed ")
    $line = ($line).replace(" BEHIND "," behind ")
    $line = ($line).replace(" privatise "," privatize ")
    $line = ($line).replace(" african "," African ")
    $line = ($line).replace(" etc "," etc. ")
    $line = ($line).replace(" POSSIBLE "," possible ")
    $line = ($line).replace(" MAY "," may ")
    $line = ($line).replace(" centred "," centered ")
    $line = ($line).replace(" BLAST "," blast ")
    $line = ($line).replace(" ENORMOUS "," enormous ")
    $line = ($line).replace(" ACTUAL "," actual ")
    $line = ($line).replace(" TIME "," time ")
    $line = ($line).replace(" BEING "," being ")
    $line = ($line).replace(" ACTING "," acting ")
    $line = ($line).replace(" etc "," etc. ")
    $line = ($line).replace(" ?","?")
    $line = ($line).replace(" !","!")
    $line = ($line).replace(" TOTALLY","totally")
    $line = ($line).replace(" weaponised","weaponized")
    $line = ($line).replace(" AGREEING","agreeing")
    $line = ($line).replace(" submited","submitted")
    $line = ($line).replace(" aztecs","Aztecs") 
    $line = ($line).replace(" AGAINST ","against")


    $line = $line.Trim()
	
	
	#Avoid lonely periods
	if ($line -eq ".")
	{
	    return
	}


	#Avoid dash periods
	if ($line -eq "-.")
	{
	    return
	}
	
	#Avoid periods dash
	if ($line -eq ".-")
	{
	    return
	}
		
        $line
}

function FindBreakPoint
{
    #In large chunk of text, split sentences between slides.
    param([string]$line)
    
    for ($i=($Global:MaxCharCount - 16); $i -gt 0; $i--)
    {
        if ($line[$i] -eq " " -and $i -gt 0)
        {
            if ($line[$i - 1] -in '.','?','!',';','*')
            {
               $i
               return
            }
        }
    }

    write-error "FindBreakPoint did not find an index!"
    write-host "$line"
    Start-Sleep 10
    exit
}

function ChopUpLines
#Split up all sentences to individual lines.
{
    param(
        [string[]]$Lines
    )
    
    $Lines | foreach-object{
       if ($_ -eq "$")
       {
           "$"
       }
       else
       {
           ChopUpLine $_
       }
    }
}

function ChopUpLine
# Split up text into individual sentences.
{
    param(
        [string]$Line
    )
    
    ###Removing embedded URLs###
    $line = RemoveURL $line
    
    #TODO Actually chop up the line.
    $Line = $Line.Replace("- ",".-`n")
    $Line = $Line.Replace(". ",".`n")
    $Line = $Line.Replace("! ","!`n")
    $Line = $Line.Replace("? ","?`n")
    $Line = $Line.Replace('." ',".`"`n")
    $Line = $Line.Replace('!" ',"!`"`n")
    $Line = $Line.Replace('?" ',"?`"`n")
    $Line = $Line -Replace '” “',"`”`n`“"
    $Line = $Line.Replace('.” ',".`”`n")
    $Line = $Line.Replace('.) ',".)`n")
    $Line = $Line.Replace(', but ',",`nbut ")
    $Line = $Line.Replace("; ",";`n")
    $Line = $Line.Replace("… ","…`n")
    $Line = $Line.Replace('.” ',".`"`n")
    $Line = $Line.Replace('!” ',"!`"`n")
    $Line = $Line.Replace('?” ',"?`"`n")
    $Line = $Line.Replace('…',"…`n")

    $Line
}


Function RemoveURL ([string] $Text)
{   
# Remove URLs in embedded links.
    while ($Text -match "\[.*?\]\(.*?\)")
    {
        $index = ($matches[0]).indexof("](")
        $new = ($matches[0])[1..($index-1)] -join ""
        $Text = $Text.replace($matches[0],$new)
    }
    
    $Text
}

function SplitTheLine
{
    param([string]$line)
    
    if ($line.length -gt ($Global:MaxCharCount - 10))
    {
        $line = RemoveURL $line
        $splitAt = FindBreakPoint $line
        #Write next line
        $line[0..($SplitAt - 1)] -join ""
        #Write a separator
        "$"
        SplitTheLine ($line[($SplitAt + 1)..($line.length - 1)] -join "")
    }
    else
    {
        $line
    }
    
}

function CharacterCount{
   #every character in an array of strings
   param([string[]]$array)
   $count = 0
   foreach ($x in $array)
   {
      $count += $x.length
   }
   $count
}

function Test-History{
   #Check to see if the URL has been used before.
   
   param (
      [string] $URL	
   )

   if ($SkipHistory)
   {
    return
   }

   if ($URL -in (Get-Content $PostHistoryLog))
   {
   	Clear-Host
   	write-host "This URL is already in the PostHistory Log"
   	Start-Sleep 1
   	exit
   }
}


function Format-Comment{
    #Removes Blank Lines & Adds "$" between lines. This is for follow along effect.
    param (
        [string]$textblock
    )
    $textblock.Split("`n") | foreach-object{
        if (($_.Trim()).length -gt 0)
        {
            if ($_.length -le $Global:MaxCharCount)
            {
                $_.Trim()
            }
            else 
           {
                SplitTheLine "$_".Trim()
                Switch ($CommentLevel)
                {
                    0 {$Global:MaxCharCount = $Lv0_1_CharCount; break}
                    1 {$Global:MaxCharCount = $Lv1_1_CharCount; break}
                    2 {$Global:MaxCharCount = $Lv2_1_CharCount; break}
                    3 {$Global:MaxCharCount = $Lv3_1_CharCount; break}
                    default {Throw "Error. Can't switch on Comment Level in Format-Comment"}
                }
            }
            "$"
        }
    }
}

function Convert-Text2Doc ($TEXT)	
{

	$word = New-Object -ComObject word.application
	$word.Visible = $false
	$doc = $word.documents.add()
	$selection = $word.Selection
	
	foreach ($line in $TEXT)
	{
            if ($line.length -gt 305)
		{
			#Change Text to BLUE
			$selection.Font.ColorIndex = 2
		} 
		$selection.TypeText($line)
		$selection.TypeText("`n")
		#Reset Text to Black
            $selection.Font.ColorIndex = 0
	}
	$doc.SaveAs("$SaveFolder\$(Get-Random)-$(Get-Random).DOCX")
	$doc.close()
	$Word.Quit()
}

#change url for use of reddit json api
$curl = $url.Replace("https://www", "https://api")
$curl += ".json"


#Check to see if post was already used
Test-History $url


$Post = (Invoke-RestMethod $curl)


#Collect the stories.  Dump when done.
$AllStories = @()

$PostAuthor = $Post[0].data.children.data.author

#Write author, question, url, author, and self-text
$AllStories += $Post[0].data.children.data.author
$AllStories += $Post[0].data.children.data.title
$AllStories += $Post[0].data.children.data.url

if ($GetSelf)
{
    $CommentLevel = 0
    $Global:MaxCharCount = $Lv0_CharCount
    $AllStories += $Post[0].data.children.data.author
    $AllStories += ChopUpLines (Format-Comment (($Post[0].data.children.data.selftext) -replace '\n',' '))
}
$AllStories += "@"


#loop on remaining content
$Post[1].data.children | foreach-object{
    if ($_.kind -eq "t1"){

                
        #Get first level author & comment
        $Story = @()
        $CommentLevel = 1
        $Global:MaxCharCount = $Lv1_CharCount
        $Story += $_.data.author
        $Story += ChopUpLines (Format-Comment (($_.data.body) -replace '\n',' '))

        
        #get 2nd level comment
        if ((("" + $_.data.replies.data.children.data[0].author).length -gt 0) -and ($GetCommentLevels -gt 1))
        {
            $Story += "#"
            $CommentLevel = 2
            $Global:MaxCharCount = $Lv2_CharCount
            $Story += $_.data.replies.data.children.data[0].author
            $Story += ChopUpLines (Format-Comment (($_.data.replies.data.children.data[0].body) -replace '\n',' '))
        }
        
        #get 3rd level comment
        if ((("" + $_.data.replies.data.children.data[0].author).length -gt 0) -and ($GetCommentLevels -gt 2))
        {
            $Story += "&"
            $CommentLevel = 3
            $Global:MaxCharCount = $Lv3_CharCount
            $Story += $_.data.replies.data.children.data[0].replies.data.children.data[0].author
            $Story += ChopUpLines (Format-Comment (($_.data.replies.data.children.data[0].replies.data.children.data[0].body) -replace '\n',' '))
        }

        #get another 2nd level comment
        if ((("" + $_.data.replies.data.children.data[1].author).length -gt 0) -and ($GetCommentLevels -gt 1))
        {
            $Story += "#"
            $CommentLevel = 2
            $Global:MaxCharCount = $Lv2_CharCount
            $Story += $_.data.replies.data.children.data[1].author
            $Story += ChopUpLines (Format-Comment (($_.data.replies.data.children.data[1].body) -replace '\n',' '))
        }
        
        #Answer seperator
        $Story += "@"
	    if ((CharacterCount $AllStories) -lt $DesiredCharacterCount)
    	{
    	   $AllStories += ,$Story
        } 
    }
}


#Trim all lines below self text.
$AllStories = $AllStories | foreach-object{
    $_.split("`n") | foreach-object{
        $_.Trim()
    }
}


#Go thru and fix common errors usually handled in reparser
if ($GetSelf)
{
    $x = 4
}
else
{
    $x = 3
}

for ($x; $x -lt $AllStories.Count; $x++)
{
    if ($AllStories[$x] -eq "#")
    {
        $x++
        continue
    }
    elseif ($AllStories[$x] -eq "@")
    {
        $x++
        continue
    }
    else
    {
        ($AllStories[$x]) = FixCommonMistakes $AllStories[$x]
    }
}


#Go thru and fix @OP and #OP and &OP by looking at every line
for ($x = 3; $x -lt $AllStories.Count; $x++)
{
    if ($AllStories[$x] -eq "#")
    {
        if ($AllStories[$x+1] -eq $PostAuthor)
        {
            $AllStories[$x] = "#OP"
        }
    }
    elseif ($AllStories[$x] -eq "@")
    {
        if ($AllStories[$x+1] -eq $PostAuthor)
        {
            $AllStories[$x] = "@OP"
        }
    }
    elseif ($AllStories[$x] -eq "&")
    {
        if ($AllStories[$x+1] -eq $PostAuthor)
        {
            $AllStories[$x] = "&OP"
        }
    }
}


#Add to PostHistory
$URL | out-file -append $PostHistoryLog


#Create the WordDoc
Convert-Text2Doc $AllStories
