/mob/living/simple_mob/vore/alienanimals/teppi/load_default_bellies()
	///////////
	/// Maw ///
	///////////
	var/obj/belly/B = new /obj/belly(src)
	vore_selected = B

	B.name = "Maw"
	B.desc = "Teppi Maw !!!"
	B.digest_mode = DM_HOLD
	B.mode_flags


	/////////////////
	/// The Tumby ///
	/////////////////
	B = new/obj/belly(src)
	food_zone = B

	B.name = "Stomach"
	B.desc = "The heat of the roiling flesh around you bakes into you immediately as you're cast into the gloom of a Teppi's primary gastric chamber. The undulations are practically smothering, clinging to you and grinding you all over as the Teppi continues about its day. The walls are heavy against you, so it's really difficult to move at all, while the heart of this creature pulses rhythmically somewhere nearby, and you can feel the throb of its pulse in the doughy squish pressing up against you. Your figure sinks a ways into the flesh as it presses in, wrapping limbs up between countless slick folds and kneading waves. It's not long before you're positively soaked in a thin layer of slime as you're rocked and squeezed and jostled in the stomach of your captor."
	B.digest_mode = DM_DRAIN
	B.mode_flags = DM_FLAG_THICKBELLY | DM_FLAG_JAMSENSORS
	B.item_digest_mode = IM_DIGEST_FOOD

	B.digest_brute = 0.05
	B.digest_burn = 0.05
	B.digestchance = 5
	B.absorbchance = 1
	B.escapechance = 15
	B.contaminates = TRUE
	B.contamination_flavor = "Wet"
	B.contamination_color = "grey"

	B.emote_lists[DM_DRAIN] = list(
		"The walls press in heavily over you, holding you tightly and grinding, churning against your body powerfully!! You can feel %pred's heartbeat through the flesh, pounding in your ears, and the groaning gurgles of the gastric chamber rolling around you, eagerly pressing in against you.",
		"The squeezing touch of the practically molten walls form to your figure, pressing in close and gliding across the shapes of your body, pressing, bending, and churning you casually! The intensity of it all is almost hard to comprehend. It is not painful, so much as just, almost completely overpowering, exhausting...",
		"The gurgling bubbling sounds of %pred's body drown out much of everything else as you're submerged in the rolling waves of wrinkled belly flesh. You can hear the flesh stretch and shift as %pred moves. The whooshing of %pred's breath catches your attention now and then, and how things seem to get tighter for you when the whoosh draws in, squeezing you that much more.",
		"The creak of muscle and bone containing you sounds through the sloppy flesh pressed in against you as %pred moves. Your body is forced into a tighter curl as %belly churns over you, forming to take up any free space. This hot, humid organic gloom seems to be totally focused on you, working hard to make use of you however it can...",
		"It's so hard to move with all the heavy flesh pressing in on you, wearing you down and making it that much harder to move as the moments pass. The squashy walls form to your figure and lets your weight sink in quite a ways before the tension builds. An idle flex of the muscles beyond shoves you back into place, and the cycle begins again.",
		"%pred's %belly rolls over you heavily a few times, burying you briefly in an intense hold and shoving you to the back end of the chamber. There's no free space, just powerful squeezes and slimy squelches! The wrinkly walls ripple over you powerfully as your body is slowly churned from one end to the other!",
		"What little air there is in here is so thick that you could cut it with a knife, HOT and humid and just totally oppressive. The throbbing bodily motions quake through you as you're jostled and tossed around amid rolling waves of wrinkled flesh, oozing with a thin slime. %pred's heart pulses in your ear and all around you as you're contained completely within the %belly, confined to the pitch black, intimate space, hidden away amid %pred.",
		"The chaotic pressing and churning all around you makes it hard to get your bearings. The sloppy presses of hot heavy flesh shove you here and squeeze you there, never leaving you alone as they enjoy you. It's hard to get ANY space to yourself, and to do so, you usually have to really fight for it, and sacrifice some other part of your body to the squeezing gropes of %pred's insistent %belly.",
		"Thick rolling waves of flesh batter against and form to you as you're smothered briefly against the doughy walls of %pred's %belly. The hold goes on for a little too long, but just as you start to worry, it eases up a little bit and gives you an ounce of space. … For about three seconds, before the chamber collapses in on you again, grinding and squeezing and churning you around idly. The grumbling symphony of that gut working on you is impossible to tune out as the burbling sound of slick flesh and goopy insides fill your ears.",
		"The walls that separate you from the outside world are thick, and not just because of the few inches of doughy, stretchy %belly lining that's containing you immediately. Beyond that there are other organs unseen, glooping and churning and glorgling outside of your chamber, then there are layers of muscle and bone, and finally a thick hide and ample fluff. This all means that, for your part, you're likely a small shifting shape under that fluffy exterior, packed away deep at the core of all of those layers, so far from the outside world as that chamber grinds and smothers over you, smearing you in slime and keeping you nice and tucked deep into the rumbling darkness.")

	B.emote_lists[DM_DIGEST] = list(
		"The walls close in on you in thick, heavy waves, smearing you in a thick slime. Working hard to churn over your figure intensely. The heat of the chamber soaks into you along with the fluids you're being lathered in. A telling tingle sets in the longer you are exposed to those fluids, while no part of you is spared from the probing churns and deep kneads of %pred's insistent %belly. . .",
		"The doughy press of %pred's %belly almost seems to feel over you, actively seeking you within that gloomy humid chamber. The sloppy burbling of that thick flesh gliding and smearing over you is impossible to ignore, the sound of your own body slapping and slurping amid those active pulsing folds and the bubbling slime a sign that you are indeed held deep within the organic confines of another's hungry gut… and it's focused on you.",
		"The sounds outside of the %belly are difficult to make out. You can hear little creaks and bumps against %pred's hide though, the sound of the skin stretching to form to your predator's shape, and to contain you deep within. Of course, the slurping, squishing, and GURGLING of that gut working around you is always more immediately apparent, along with the heavy throbbing of %pred's heart.",
		"You find that as you're rocked and ground amid the gurgling %belly, the ever present thumping drone of %pred's heartbeat pounds in your ears, the powerful thudding of it pulses through the flesh holding you, throbbing across every wrinkle and fold, every surface presses in at you just that little bit more with each and every throb of that heartbeat. The burbling grumbles of that gut working around you too, fill your ears with a deep gastric symphony as those walls work hard to break you down.",
		"The gurgling walls press in heavily, overpowering your limbs briefly as the chamber collapses in to grind over you from head to toe!! No part of you is left out as the doughy flesh glides and grinds and jostles you around, smothering you in thick slime here and squeezing you down into a tight little ball there. The satisfied puffing coming from nearby through the flesh all you need to know that %pred is happy to have you.",
		"The slime bubbles and glorps around you as you're smothered in those thick walls! The slick surfaces mold to your figure as the throbbing of %pred's pulse squeezes you that little bit more with each beat of their heart. The tingling caused by that slime spreads all across your body as you're totally soaked in it, and there's nowhere within this chamber to get away from it!",
		"The roaring gurgles of the active gut squeezing and squelching in around you sound out for a few moments as you are smushed and squeezed intensely! This is it! %pred's %belly is trying to claim you utterly!!!! But after a few moments the chamber eases off, leaving you sopping wet with thick, stringy slime.",
		"It's so hot, sweltering even! The burbling sounds of this organic cacophony swell and ebb all around you as thick slimes gush around you with the motion of %pred's %belly. It's hard to move in this tingly embrace even though the squashy walls are absolutely slippery! You can pull your limbs out from between the heavy meaty folds with some effort, and when you do there's a messy sucking noise in the wake of the motion. Of course, such a disturbance naturally warrants that the chamber would redouble its efforts to subdue you and smother you in those thick tingling slimes.",
		"The walls around you flex inward briefly, burbling and squelching heavily as everything rushed together, wringing you powerfully for a few moments while, somewhere far above you can hear the bassy rumble of a casual belch, much of the small amount of acrid air available rushing out with the sound. After several long moments held in the tight embrace of that pulsing flesh, things ease up a bit again and resume their insistent, tingly churnings.",
		"It's pitch black and completely slimy in here, %pred sways their %belly a bit here and there to toss you from one end to the other, tumbling you end over end as you're churned in that active %belly. It's all so slick and squishy, so it is really hard to get any footing or grip on things to stabilize your position, which means that you're left at the mercy of those gloomy gastric affections and the tingling touch of those sticky syrupy slimes that the walls lather into your body.")

	B.emote_lists[DM_HOLD] = list(
		"The burbling %belly rocks and glides over you gently as you're held deep within %pred, the deep thumping of their heart pulses all around you as you're caressed and pressed by heavy, doughy walls.",
		"%pred's %belly glorgles around you idly as you're held gently by the slick, wrinkled flesh.",
		"The ever present beating of %pred's heart throbs through the chamber around you. As you sink into the flesh a little ways, you can feel the pressure of the pulse pump in against you that much more snug for an instant, just in time with the thump of the nearby heart.",
		"As %pred breathes you can feel the %belly you are within compact in against you a bit more, the pressure of the inflating lungs smooshing the other organs out of the way a bit, and giving you a bit more of a squeeze, before with a whoosh the breath rushes out again, and the cycle repeats.",
		"As %pred goes about their day you can feel the motions of their body jostle you a bit here and there. Bumping and bouncing you against the doughy pressure of those interior confines, the gloopy gurgles sounding off from somewhere deeper inside...",
		"The walls press in heavily on you for a few moments. Squeezing across you in a heavy, possessive churn. A smothering squeeze that leaves you breathless for a few long moments, coating you in a thin layer of slick slime. The walls seem to retreat reluctantly, leaving you in the sweltering humid air of %pred's cramped %belly.",
		"It's hard to stay in place with how slick and squashy the walls of %pred's %belly are. Thick and smushy and soft, you can sink into them several inches before the tension catches you and rolls you around at the crater your body weight makes. A pool of thin slimes gathers around you some, clinging close as you're held snugly deep within %pred.",
		"The press of slick flesh to your body and in against itself is ever present within this slimy space. The squelches and grumbles of that tummy shifting around you never really go away. The wrinkled walls would glide against themselves here and there creating an idle cacophony of squish, while the caress of that flesh in against your body makes a more prevalent slurping that's hard to escape.",
		"Held within the pitch black gloom of this gently churning organic chamber it's hard to get much room to yourself. The walls are always prone to rolling in and squeezing over you for long moments.",
		"Despite the constant motion of fleshy waves gliding in against you and the burbling sounds of the inner workings of all those tubes and organs, the steady beating of %pred's heart, and the gentle whooshing of their breath were surprisingly relaxing.")

	B.emote_lists[DM_ABSORB] = list(
		"The intensity of the flesh pumping in against you makes it somewhat hard to tell how soft and tarry the surfaces pressing into you have gotten. As your extremities disappear between the folds of flesh inside there it's so difficult to pull them back out, like squirming against  hot, gooey quicksand! %pred's %belly seems quite insistent on sinking you deeper, and claiming you entirely.",
		"The pressure is intense, the slimy walls rolling over you again and again, really clinging to your figure, sticky and slurpy, you can feel the tug of the flesh drawing you in, and the flickers of another presence along the edges of your mind.",
		"The wrinkled flesh flows between your fingers and wraps in against your body as it presses in and clings to you. The walls are extremely soft, so much so that you can sink deep into them, where, a curious tingling begins to tickle at you the deeper you go.",
		"The pulse of %pred's heart throbs all around you, through the flesh and up against you. A powerful pumping that rolls through every little bit of the %belly. The softening walls steadily flow over you, steadily sinking you into their surface a ways where that throbbing seems to get that much more intense, pulsing all around you as the flesh forms skin tight to you… and your heart seems to adjust too, thumping in your ears in time with %pred's.",
		"The pressure of %pred's body forming against you makes it hard to move at all. The walls fold in against you, wrapping you up and steadily submerging you, a texture something akin to molten marshmallow hugs you all around, filling in the creases and spaces between, but even as you're held there so tightly, you'd find that you're neither crushed nor suffocated… Held so deep and tight as that %belly works to make you one with it.",
		"As the flesh of %pred's %belly forms against you and flows across your body, you can feel and hear the wet slide of its weight spreading and rubbing against you. As it forms against your ears though and really clings on to you, the sloppy wet sounds of the interior of some weird alien fade, to be replaced by a powerful thumping heartbeat. As you sink into %pred's body, it becomes harder and harder to identify where you end and %pred begins, and that pumping heartbeat lulls your mind into something of a dull haze.",
		"As the gooey touch of %pred's body rolls over you, you can't help but notice just how soft it all is, despite the intensity of the pressure squeezing in against you, clinging to your figure in an insistent smothering embrace, it's never painful. The flesh you're being held against forms to you, molding against you, creating a space that's perfectly sized for you. A cavity shaped exactly like you. A place where you belong.",
		"As the pumping flesh courses against you, gliding and throbbing against your touch, letting you sink in far beyond where it seems reasonable for tension to have caught you, you notice that whatever appendage has sunk that deep begins to feel a bit tingly, a bit starry, like it's become a twinkling starlight. It's weird, but not exactly uncomfortable. There's a sense of otherness that brushes comfortably somewhere against the back of your mind, that gets stronger the deeper you sink...",
		"The rippling touch of %pred's wrinkled flesh folding in against you is hard to escape. No matter where you turn, it's all closing in on you, pressing to you. Practically molten, the pressure of it all molds to you and leaves no part of your figure untouched, and yet, even as it forms skin tight in against you, it doesn't stop there. You seem to still sink further into the squish, the surface of it all flows over your figure and submerges you deeper, and deeper… and deeper, until there's nothing but the heat and the throb of %pred's heart all around you.",
		"The pressure is intense. The throbbing of %pred's heart in your ears is impossible to ignore as the weight of your predator shifts when they move. You might notice that, as you sink deeper into the pressure of %pred, you're more conscious of those shifts and wobbles, as if they were your own, and the appreciative flickerings of consciousness that seems to have claimed you. You can feel each shift and jiggle of the fluffy critter's movements as you're absorbed...")

	B.emote_lists[DM_HEAL] = list(
		"The walls glide over you tenderly, gently. Lightly kneading and massaging against your figure, smooth and pillowy soft. You can sink in a ways, but it's not hard to extract yourself from these caressing touches. The burbling of %pred's %belly fills your ears as you're rocked and cradled within.",
		"As you soak within %pred's %belly you can feel some of your strength returning, aches and pains easing some as time goes on. The walls knead over you gently, but are never rough. They're soft and smushy, like a jiggly padding, protecting you from the outside world.",
		"The throb of %pred's heart rocks through the surfaces of the %belly. Even as you're sunk into a bit of a crater in the flesh there, you can feel it pulse through the squish. The sound of %pred's heart is a constant companion, along with the wet squelches and slurps of flesh shifting against itself and you.",
		"The slow sway of %pred's body as it moves rocks you back and forth across the %belly. With how soft and gentle it is in there, it's not unlike relaxing in a large, dark fleshy hammock. Of course, there's not really any airflow or even all that much space, what with the walls pressed in close and gently churning and kneading against you, so it's not anything like a hammock, really… but you might be able to imagine it was if you put your mind to it. Either way, the gentle sway is soothing and comfortable despite how un-hammock-like this hammock is...",
		"The smooth press of flesh throbs against you as %pred's %belly kneads and smooshes over you soothingly. The pressure shifts here and there as the muscles beyond grind over you carefully. Despite the heat and the thick, stifling air, you feel slowly more refreshed as you're held in here. It's comfy enough to nap in.",
		"As you're held within the %belly you feel your eyelids get a bit heavy… the rhythmic thumping of %pred's heart nearby, along with the gentle rocking shifts make snoozing an easy option, especially considering how SQUOOSHY and comfortable the stretchy flesh holding you is. It kneads and caresses you soothingly, and you might find that now and then your blinks seem to last several minutes as you're kept close amid that comfortable %belly.",
		"The walls of the %belly press in close around you for a few moments, squeezing you heavily and kneading across you. You can feel your back and joints pop here and there in just the right way, there is a moment of a kind of ache, and then a deep, delightful relief, as the walls ease up and resume their gentle smooshes.",
		"With each step %pred takes, those soft, smooth wall jiggle lightly around you, quaking and swaying you this way and that. The slimy surfaces of %pred's interior glide over your body casually, shifting and burbling here and there, holding you nice and secure.",
		"The pressure around you increases a little bit each time you hear the whooooosh of %pred taking a breath in. Expanding lungs compact things inside a little bit, making your stay just that little bit more snug. The pressure is never not gentle though. Those smooth, slick walls were also always pressing and kneading against you too, so it might not be the easiest thing to notice.",
		"The thumping, squeezing, kneading rhythm of %pred's body was easy to get into. A gentle rocking here, a little bob there, a pulsing throb across the whole %belly as you're churned and felt over. It's easy to get lost in the grumbly gurgly rhythm of that body, hidden away in the pitch black. As it all works around you, you can feel your energy build, your muscles relax, and any aches and pains you might have would fade with time. It's comfortable, and fills you with an alien sense of belonging.")

	B.struggle_messages_inside = list(
		"As you squirm and fuss, your limbs sink into the squish a fair way! Sliding over the slick, sloppy surfaces of %pred's %belly. The walls clamp in and churn over you heavily in response.",
		"As you squirm, %pred's %belly wobbles and smothers over you. Wrinkled walls fold against your features. The humid air hangs around you oppressively as the walls roll over you, making it hard to move.",
		"You can feel the pressure of the flesh kneading you clamp down and fold over you insistently as you squirm and push at %pred's flesh. It's so slippery and hard to get any proper grip or footing!",
		"When you shift your weight and press into the flesh of %pred's %belly, you can feel things around you clamp down, and in a rush, what little air there is inside of there rushes out passed you. %pred emits a low, rumbling urp somewhere far above.",
		"Your struggles slide over the doughy flesh. The tension of it catches you and forms to your presses, before it all flexes inward again and tries to fold you into a smaller shape again.",
		"When you push and squirm against the walls of the %belly, you can hear and feel %pred give a little happy grumble, and you can feel them shift their weight, tossing you from one end of the %belly to the other, sloppy squelching sounding out as you land.",
		"Your hands slip and slide against the pulsing wrinkled squish of %pred's %belly, sinking into the doughy texture of the smooth walls and makes it hard to go anywhere except to the lowest, deepest section of the %belly.",
		"The sound of your squirms is loud in your ears. The squelchy gurgly sound of sloppy wet flesh shifting in the pitch black, as your struggles force the tight space wider as you try to wriggle free.",
		"When you move the %belly gurgles insistently around you. The bubbling fluids within there cling to you as you push and squirm against those wrinkly walls.",
		"Your struggles are stifled by the clinging press of heavy flesh greedily pressing in on you heavily. It's tiring to fight against those groaning guts...")

	B.struggle_messages_outside = list(
		"Vague shapes shift under %pred's hide...",
		"Something solid squirms within %pred...",
		"%pred emits a low 'uurp' as something shifts within.",
		"Something bumps and thumps against the inside of %pred.",
		"Something glorps inside of %pred.",
		"%pred's gut grumbles around something solid...",
		"%pred's belly rumbles and sways as something moves inside.",
		"Something sloshes inside of %pred.",
		"%pred's belly burbles noisily.",
		"%pred's belly shifts noticeably.")
	B.examine_messages = list(
		"There is a noticable swell on their belly.",
		"Their belly seems to hang a bit low.",
		"There seems to be a solid shape distending their belly.")
	B.digest_messages_prey = list(
		"With a low grumble your body melts and falls apart within %pred. The nutrition you provide would go on to power your predator as they go on with their life. You were nutritious food, but, nothing but alien food in the end.",
		"No matter your squirms and fusses you can feel those walls collapse in on you, smothering over you as the tingling fluids rise and bubble against you. Churning hard as your body is actively softened up and melted away! Your senses fading out as you're reduced to nothing but a hot, gooey slush, a form much better suited to continuing on as food for a hungry body.",
		"As your body weakens and your wiggles ebb down, the pressure of those churning walls builds, further overpowering and working to melt you that much more. The thick syrupy slime soaks into you and softens you up, not unlike ice cream on a hot summer day, and you're soaked up just as easily.",
		"%pred's %belly gushes and schlorps around you as you are broken down and absorbed. The rippling walls churn and roll the slowly thinning contents of their sloshing depths, as more and more of you is claimed completely by %pred.",
		"The gurgling sounds of your body melting slowly overtakes all the other sounds. The walls closing in and squeezing over you so heavily! Nothing you could do could help you now as you're churned and mushed, left to steadily soften and break up into a nutritious slush. ",
		"Your body softens and glorps around within the guts of %pred. The rolling rumbles and sloshes overcome you as your senses fade, and your form fades away, bubbling away to become nothing more than a part of %pred.",
		"Things clamp down over you as %pred flexxes, smothering over you for a few long moments. Your senses fade away before they ease up though. Your body rapidly melted down and made to slosh through the deeper tubes, helpless but to fade away as you're absorbed as the food you are.",
		"The tide of syrupy fluids rises higher and higher, flooding over you, leaving nothing to breathe. Your senses fade away as the sloppy roiling mess softens you up and passes you along for further processing, fit only to serve to plump up %pred's figure.",
		"Over the course of several hours in the burbling organic cauldron, your body softens up little by little, soaking up the slime, the tingling spreading over you more and more as your strength fades. The walls fold over you and wrap you up, until the last thing you can sense is the throb of %pred's heart pulsing through the very core of your being, washing you away as you become food for %pred.",
		"Your final moments are spent trying to make just a little space for yourself, the doughy squish of the flesh forming to you, pressing in tighter and tighter, invading your personal space as if to show you that, you don't have any personal space. You're already a part of %pred, you just don't know it yet. And so those walls come in close to press up against you and churn you away into a messy slop, to put you in your place. That being, padding the belly and hips of %pred, right where you belong.")

	////////////////////////
	/// The friend zone. ///
	////////////////////////
	B = new /obj/belly(src)
	friend_zone = B

	B.immutable = TRUE
	B.affects_vore_sprites = TRUE
	B.mode_flags = DM_FLAG_THICKBELLY | DM_FLAG_JAMSENSORS
	B.human_prey_swallow_time = 0.01 SECONDS
	B.digestchance = 0
	B.digest_brute = 0
	B.digest_burn = 0
	B.absorbchance = 0
	B.escapable = B_ESCAPABLE_DEFAULT
	B.escapechance = 40
	B.digest_mode = DM_HEAL
	B.name = "propeutpericulum" 	//I'm no latin professor I just know that some organs and things are based on latin words
									//and google translate says that each of these individually
									//"close" "to" "danger" translate to "prope" "ut" "periculum".
									//Of course it doesn't translate perfectly, and it's nonsense when squashed together, but
									//I don't care that much, I just figured that the weird alien animals that store friends in
									//their tummy should have a funny name for the organ they do that with. >:I
	B.desc = "You seem to have found your way into something of a specialized chamber within the Teppi. \
			The walls are slick and smooth and REALLY soft to the touch. While you can hear the Teppi's heartbeat nearby, \
			and feel it throb throughout its flesh, the motions around you are gentle and careful. You're pressed into a small \
			shape within the pleasant heat, with the flesh forming to your figure. You can wriggle around a bit and get \
			comfortable here, but as soon as you get still for a bit the smooth, almost silky flesh seems to form to you \
			once again, like a heavy blanket wrapping you up. As you lounge here the pleasant kneading sensations ease aches \
			and pains, and leave you feeling fresher than before. For a curious fleshy sac inside of some alien monster, \
			this place isn't all that bad!"
	B.contaminates = 1
	B.contamination_flavor = "Wet"
	B.contamination_color = "grey"
	B.item_digest_mode = IM_HOLD
	B.fancy_vore = 1
	B.vore_verb = "nyomp"

	B.emote_lists[DM_DRAIN] = food_zone.emote_lists[DM_DRAIN]

	B.emote_lists[DM_DIGEST] = food_zone.emote_lists[DM_DIGEST]

	B.emote_lists[DM_HOLD] = food_zone.emote_lists[DM_HOLD]

	B.emote_lists[DM_ABSORB] = food_zone.emote_lists[DM_ABSORB]

	B.emote_lists[DM_HEAL] = food_zone.emote_lists[DM_HEAL]

	B.struggle_messages_inside = food_zone.struggle_messages_inside

	B.struggle_messages_outside = food_zone.struggle_messages_outside

	B.examine_messages = food_zone.examine_messages

	B.digest_messages_prey = food_zone.digest_messages_prey

	//////////////////
	/// Tepp Tubes /// //Probably not for the final release...
	////////////////// //But Gosh... I'd love to get pumped through teppi intestines.
	B = new /obj/belly(src)

	B.name = "deep tubes"
	B.desc = "heavy, smothering flesh presses into you on all sides as the overwhelming warmth of the Teppi's heavy-duty tract sloppily sucks you along. The Teppi's guts roughly dragging the slime-covered walls across your oppressed form as they gloop and glrrn with each pump moving you along, in whichever direction that may be in."
	B.vore_verb = "smush"
