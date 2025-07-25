import { useBackend } from '../backend';
import {
  Box,
  Button,
  Collapsible,
  Stack,
  LabeledList,
  NoticeBox,
  NumberInput,
  Section,
} from 'tgui-core/components';
import { Window } from '../layouts';

export const NaniteChamberControl = (props) => {
  return (
    <Window width={380} height={570} resizable>
      <Window.Content scrollable>
        <NaniteChamberControlContent />
      </Window.Content>
    </Window>
  );
};

export const NaniteChamberControlContent = (props) => {
  const { act, data } = useBackend();
  const {
    status_msg,
    locked,
    occupant_name,
    has_nanites,
    nanite_volume,
    regen_rate,
    safety_threshold,
    cloud_id,
    scan_level,
  } = data;

  if (status_msg) {
    return <NoticeBox textAlign="center">{status_msg}</NoticeBox>;
  }

  const mob_programs = data.mob_programs || [];

  return (
    <Section
      title={'Chamber: ' + occupant_name}
      buttons={
        <Button
          icon={locked ? 'lock' : 'lock-open'}
          content={locked ? 'Locked' : 'Unlocked'}
          color={locked ? 'bad' : 'default'}
          onClick={() => act('toggle_lock')}
        />
      }
    >
      {!has_nanites ? (
        <>
          <Box bold color="bad" textAlign="center" fontSize="30px" mb={1}>
            No Nanites Detected
          </Box>
          <Button
            fluid
            bold
            icon="syringe"
            content=" Implant Nanites"
            color="green"
            textAlign="center"
            fontSize="30px"
            lineHeight="50px"
            onClick={() => act('nanite_injection')}
          />
        </>
      ) : (
        <>
          <Section
            title="Status"
            level={2}
            buttons={
              <Button
                icon="exclamation-triangle"
                content="Destroy Nanites"
                color="bad"
                onClick={() => act('remove_nanites')}
              />
            }
          >
            <Stack>
              <Stack.Item>
                <LabeledList>
                  <LabeledList.Item label="Nanite Volume">
                    {nanite_volume}
                  </LabeledList.Item>
                  <LabeledList.Item label="Growth Rate">
                    {regen_rate}
                  </LabeledList.Item>
                </LabeledList>
              </Stack.Item>
              <Stack.Item>
                <LabeledList>
                  <LabeledList.Item label="Safety Threshold">
                    <NumberInput
                      value={safety_threshold}
                      minValue={0}
                      maxValue={500}
                      width="39px"
                      onChange={(value) =>
                        act('set_safety', {
                          value: value,
                        })
                      }
                    />
                  </LabeledList.Item>
                  <LabeledList.Item label="Cloud ID">
                    <NumberInput
                      value={cloud_id}
                      minValue={0}
                      maxValue={100}
                      step={1}
                      stepPixelSize={3}
                      width="39px"
                      onChange={(value) =>
                        act('set_cloud', {
                          value: value,
                        })
                      }
                    />
                  </LabeledList.Item>
                </LabeledList>
              </Stack.Item>
            </Stack>
          </Section>
          <Section title="Programs" level={2}>
            {mob_programs.map((program) => {
              const extra_settings = program.extra_settings || [];
              const rules = program.rules || [];
              return (
                <Collapsible key={program.name} title={program.name}>
                  <Section>
                    <Stack>
                      <Stack.Item>{program.desc}</Stack.Item>
                      {scan_level >= 2 && (
                        <Stack.Item size={0.6}>
                          <LabeledList>
                            <LabeledList.Item label="Activation Status">
                              <Box color={program.activated ? 'good' : 'bad'}>
                                {program.activated ? 'Active' : 'Inactive'}
                              </Box>
                            </LabeledList.Item>
                            <LabeledList.Item label="Nanites Consumed">
                              {program.use_rate}/s
                            </LabeledList.Item>
                          </LabeledList>
                        </Stack.Item>
                      )}
                    </Stack>
                    {scan_level >= 2 && (
                      <Stack>
                        {!!program.can_trigger && (
                          <Stack.Item>
                            <Section title="Triggers" level={2}>
                              <LabeledList>
                                <LabeledList.Item label="Trigger Cost">
                                  {program.trigger_cost}
                                </LabeledList.Item>
                                <LabeledList.Item label="Trigger Cooldown">
                                  {program.trigger_cooldown}
                                </LabeledList.Item>
                                {!!program.timer_trigger_delay && (
                                  <LabeledList.Item label="Trigger Delay">
                                    {program.timer_trigger_delay} s
                                  </LabeledList.Item>
                                )}
                                {!!program.timer_trigger && (
                                  <LabeledList.Item label="Trigger Repeat Timer">
                                    {program.timer_trigger} s
                                  </LabeledList.Item>
                                )}
                              </LabeledList>
                            </Section>
                          </Stack.Item>
                        )}
                        {!!(
                          program.timer_restart || program.timer_shutdown
                        ) && (
                          <Stack.Item>
                            <Section>
                              <LabeledList>
                                {/* I mean, bruh, this indentation level
                                    is ABSOLUTELY INSANE!!! */}
                                {program.timer_restart && (
                                  <LabeledList.Item label="Restart Timer">
                                    {program.timer_restart} s
                                  </LabeledList.Item>
                                )}
                                {program.timer_shutdown && (
                                  <LabeledList.Item label="Shutdown Timer">
                                    {program.timer_shutdown} s
                                  </LabeledList.Item>
                                )}
                              </LabeledList>
                            </Section>
                          </Stack.Item>
                        )}
                      </Stack>
                    )}
                    {scan_level >= 3 && !!program.has_extra_settings && (
                      <Section title="Extra Settings" level={2}>
                        <LabeledList>
                          {extra_settings.map((extra_setting) => (
                            <LabeledList.Item
                              key={extra_setting.name}
                              label={extra_setting.name}
                            >
                              {extra_setting.value}
                            </LabeledList.Item>
                          ))}
                        </LabeledList>
                      </Section>
                    )}
                    {scan_level >= 4 && (
                      <Stack>
                        <Stack.Item>
                          <Section title="Codes" level={2}>
                            <LabeledList>
                              {!!program.activation_code && (
                                <LabeledList.Item label="Activation">
                                  {program.activation_code}
                                </LabeledList.Item>
                              )}
                              {!!program.deactivation_code && (
                                <LabeledList.Item label="Deactivation">
                                  {program.deactivation_code}
                                </LabeledList.Item>
                              )}
                              {!!program.kill_code && (
                                <LabeledList.Item label="Kill">
                                  {program.kill_code}
                                </LabeledList.Item>
                              )}
                              {!!program.can_trigger &&
                                !!program.trigger_code && (
                                  <LabeledList.Item label="Trigger">
                                    {program.trigger_code}
                                  </LabeledList.Item>
                                )}
                            </LabeledList>
                          </Section>
                        </Stack.Item>
                        {program.has_rules && (
                          <Stack.Item>
                            <Section title="Rules" level={2}>
                              {rules.map((rule) => (
                                <Box key={rule.display}>{rule.display}</Box>
                              ))}
                            </Section>
                          </Stack.Item>
                        )}
                      </Stack>
                    )}
                  </Section>
                </Collapsible>
              );
            })}
          </Section>
        </>
      )}
    </Section>
  );
};
