import { useBackend } from '../backend';
import {
  Button,
  Dropdown,
  Stack,
  Input,
  LabeledList,
  NoticeBox,
  NumberInput,
  Section,
} from 'tgui-core/components';
import { Window } from '../layouts';

export const NaniteCodes = (props) => {
  const { act, data } = useBackend();
  return (
    <Section title="Codes" level={3} mr={1}>
      <LabeledList>
        <LabeledList.Item label="Activation">
          <NumberInput
            value={data.activation_code}
            width="47px"
            minValue={0}
            maxValue={9999}
            onChange={(value) =>
              act('set_code', {
                target_code: 'activation',
                code: value,
              })
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Deactivation">
          <NumberInput
            value={data.deactivation_code}
            width="47px"
            minValue={0}
            maxValue={9999}
            onChange={(value) =>
              act('set_code', {
                target_code: 'deactivation',
                code: value,
              })
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Kill">
          <NumberInput
            value={data.kill_code}
            width="47px"
            minValue={0}
            maxValue={9999}
            onChange={(value) =>
              act('set_code', {
                target_code: 'kill',
                code: value,
              })
            }
          />
        </LabeledList.Item>
        {!!data.can_trigger && (
          <LabeledList.Item label="Trigger">
            <NumberInput
              value={data.trigger_code}
              width="47px"
              minValue={0}
              maxValue={9999}
              onChange={(value) =>
                act('set_code', {
                  target_code: 'trigger',
                  code: value,
                })
              }
            />
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};

export const NaniteDelays = (props) => {
  const { act, data } = useBackend();

  return (
    <Section title="Delays" level={3} ml={1}>
      <LabeledList>
        <LabeledList.Item label="Restart Timer">
          <NumberInput
            value={data.timer_restart}
            unit="s"
            width="57px"
            minValue={0}
            maxValue={3600}
            onChange={(value) =>
              act('set_restart_timer', {
                delay: value,
              })
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Shutdown Timer">
          <NumberInput
            value={data.timer_shutdown}
            unit="s"
            width="57px"
            minValue={0}
            maxValue={3600}
            onChange={(value) =>
              act('set_shutdown_timer', {
                delay: value,
              })
            }
          />
        </LabeledList.Item>
        {!!data.can_trigger && (
          <>
            <LabeledList.Item label="Trigger Repeat Timer">
              <NumberInput
                value={data.timer_trigger}
                unit="s"
                width="57px"
                minValue={0}
                maxValue={3600}
                onChange={(value) =>
                  act('set_trigger_timer', {
                    delay: value,
                  })
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label="Trigger Delay">
              <NumberInput
                value={data.timer_trigger_delay}
                unit="s"
                width="57px"
                minValue={0}
                maxValue={3600}
                onChange={(value) =>
                  act('set_timer_trigger_delay', {
                    delay: value,
                  })
                }
              />
            </LabeledList.Item>
          </>
        )}
      </LabeledList>
    </Section>
  );
};

export const NaniteExtraEntry = (props) => {
  const { extra_setting } = props;
  const { name, type } = extra_setting;
  const typeComponentMap = {
    number: <NaniteExtraNumber extra_setting={extra_setting} />,
    text: <NaniteExtraText extra_setting={extra_setting} />,
    type: <NaniteExtraType extra_setting={extra_setting} />,
    boolean: <NaniteExtraBoolean extra_setting={extra_setting} />,
  };
  return (
    <LabeledList.Item label={name}>{typeComponentMap[type]}</LabeledList.Item>
  );
};

export const NaniteExtraNumber = (props) => {
  const { extra_setting } = props;
  const { act } = useBackend();
  const { name, value, min, max, unit } = extra_setting;
  return (
    <NumberInput
      value={value}
      width="64px"
      minValue={min}
      maxValue={max}
      unit={unit}
      onChange={(e, val) =>
        act('set_extra_setting', {
          target_setting: name,
          value: val,
        })
      }
    />
  );
};

export const NaniteExtraText = (props) => {
  const { extra_setting } = props;
  const { act } = useBackend();
  const { name, value } = extra_setting;
  return (
    <Input
      value={value}
      width="200px"
      onInput={(e, val) =>
        act('set_extra_setting', {
          target_setting: name,
          value: val,
        })
      }
    />
  );
};

export const NaniteExtraType = (props) => {
  const { extra_setting } = props;
  const { act } = useBackend();
  const { name, value, types } = extra_setting;
  return (
    <Dropdown
      over
      selected={value}
      width="150px"
      options={types}
      onSelected={(val) =>
        act('set_extra_setting', {
          target_setting: name,
          value: val,
        })
      }
    />
  );
};

export const NaniteExtraBoolean = (props) => {
  const { extra_setting } = props;
  const { act } = useBackend();
  const { name, value, true_text, false_text } = extra_setting;
  return (
    <Button.Checkbox
      content={value ? true_text : false_text}
      checked={value}
      onClick={() =>
        act('set_extra_setting', {
          target_setting: name,
        })
      }
    />
  );
};

export const NaniteProgrammer = (props) => {
  return (
    <Window width={420} height={550} resizable>
      <Window.Content scrollable>
        <NaniteProgrammerContent />
      </Window.Content>
    </Window>
  );
};

export const NaniteProgrammerContent = (props) => {
  const { act, data } = useBackend();
  const {
    has_disk,
    has_program,
    name,
    desc,
    use_rate,
    can_trigger,
    trigger_cost,
    trigger_cooldown,
    activated,
    has_extra_settings,
    extra_settings = {},
  } = data;
  if (!has_disk) {
    return (
      <NoticeBox textAlign="center">Insert a nanite program disk</NoticeBox>
    );
  }
  if (!has_program) {
    return (
      <Section
        title="Blank Disk"
        buttons={
          <Button icon="eject" content="Eject" onClick={() => act('eject')} />
        }
      />
    );
  }
  return (
    <Section
      title={name}
      buttons={
        <Button icon="eject" content="Eject" onClick={() => act('eject')} />
      }
    >
      <Section title="Info" level={2}>
        <Stack>
          <Stack.Item>{desc}</Stack.Item>
          <Stack.Item size={0.7}>
            <LabeledList>
              <LabeledList.Item label="Use Rate">{use_rate}</LabeledList.Item>
              {!!can_trigger && (
                <>
                  <LabeledList.Item label="Trigger Cost">
                    {trigger_cost}
                  </LabeledList.Item>
                  <LabeledList.Item label="Trigger Cooldown">
                    {trigger_cooldown}
                  </LabeledList.Item>
                </>
              )}
            </LabeledList>
          </Stack.Item>
        </Stack>
      </Section>
      <Section
        title="Settings"
        level={2}
        buttons={
          <Button
            icon={activated ? 'power-off' : 'times'}
            content={activated ? 'Active' : 'Inactive'}
            selected={activated}
            color="bad"
            bold
            onClick={() => act('toggle_active')}
          />
        }
      >
        <Stack>
          <Stack.Item>
            <NaniteCodes />
          </Stack.Item>
          <Stack.Item>
            <NaniteDelays />
          </Stack.Item>
        </Stack>
        {!!has_extra_settings && (
          <Section title="Special" level={3}>
            <LabeledList>
              {extra_settings.map((setting) => (
                <NaniteExtraEntry key={setting.name} extra_setting={setting} />
              ))}
            </LabeledList>
          </Section>
        )}
      </Section>
    </Section>
  );
};
