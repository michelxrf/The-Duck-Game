# THE DUCK GAME

#### Video Demo: https://www.youtube.com/watch?v=TNFdmY6pM9w
#### Download the game at: https://michelxrf.itch.io/the-duck-game
#### Description:

This is a 2D top down shooter game where you'll guide a rubber duck through a series of levels, fighting through hordes of enemies until you finish the game.

The story is that this is the final test for a course for rubber ducks to become debugger ducks. Once you finish it, you (the duck) will get a certificate that allow you to work as a professional debugger.

This idea was inspired by the CS50 Duck and the problem set 7. I wanted to make something that was related to the course somehow. The funny and lightweight way the course refers to this duck gave me a good setting to make a game. And since I had to learn from zero how to make a game and learn how to use Godot Engine I had low expectations for what I could do, then I needed something silly so it wouldn't be taken too seriously.

I had planned lots of thing for it, like procedurally generated maps, lights and shadows, lots of enemy types, lots of guns, but I had also decide not to work more than a month on it. So as I made the first enemy and weapon I started working on the mechanics and noticed that I had to cut back some of the features or it would become too complex for me to handle.

I've cut back the random maps and ended up with just a couple weapons and a couple enemy types for simplicity. I also decide not to work with lights and shadows, but because it didn't fit the game's mood, I've managed to put it in the game and it was quite easy actually, but the effects made the game look too serious and I wanted the game to look silly.

I expected the enemies AI to be the hardest part, but actually it was very straight forward. Had to make lots of small adjustments along the way but the player tracking and following was done quite fast by just picking the player's locatation, rotation toward it and applying an impulse, then the harder part was to adjust what was too much impulse and too little. But the enemies ended up orbitating around the player, so I've implemented that every time the player was at a certain distance away the enemy would stop, aim at player and throw itself again. This way they could not orbitate for long.

After this was made I've separated it's behavior into idle and hunt modes. The enemy stayed in idle state wandering slowly through the map and once the palyer entrered it's "vision" area the enemy would change into hunt mode and start tracking and moving toward the player at a higher speed.

I also added an enemy that spawned other enemies, it was quite simple: it would change between states, like a state machine, based on a timer and every certain amount of time it would change into spawn, vunerable and hidden states, and spawning new enemies at each cycle. Had to implement a population control or it would fill up the map. Then I made it keep track of how many children it had and only came out of hidding to spawn more once this number was low enough.

The boss I've started trying to use 2d skeletons to animated, but after almost a whole day working at it I've decide it was taking too much time and effort to make very little progress. So I've cut back it's animation complexity and now it actually just rotate in place. It's AI was fun to work with, but very simple too, it is a variation of the spwaner, it spawns enemies based on a timer but also spawns when hit, and the timers go shorter as its health goes down. Had to limit its children population too and make the "on hit" spawns also based on health on the account that it was just too hard to beat the boss.

And now that it's complete I'm actually very proud of the game. It's quite simple and short, but it works better than what I expected at first and I managed to accomplish a quality superior than what I intended. I really enjoyed doing this project.

Learning Godot and GDScript was a challenge at first, but the engine ahve a very good documentation and quite active community, so it was very quick for me to get the basics done.