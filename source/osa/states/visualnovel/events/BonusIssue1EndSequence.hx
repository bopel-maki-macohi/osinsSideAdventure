package osa.states.visualnovel.events;

class BonusIssue1EndSequence extends EventRunner
{

    override public function new() {
        super(NONE);
    }

    override function runDialogueEvent(eventManager:EventManager, ?params:Array<String>) {
        super.runDialogueEvent(eventManager, params);

        // play teleport sound
        // maybe the sonic mania phantom ruby one?

        _game.changeLine(1);
    }
    
}