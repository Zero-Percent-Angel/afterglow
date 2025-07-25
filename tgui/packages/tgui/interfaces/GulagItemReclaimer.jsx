import { useBackend } from '../backend';
import { Button, NoticeBox, Section, Table } from 'tgui-core/components';
import { Window } from '../layouts';

export const GulagItemReclaimer = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    mobs = [],
  } = data;
  return (
    <Window
      width={325}
      height={400}
      resizable>
      <Window.Content scrollable>
        {mobs.length === 0 && (
          <NoticeBox>
            No stored items
          </NoticeBox>
        )}
        {mobs.length > 0 && (
          <Section title="Stored Items">
            <Table>
              {mobs.map(mob => (
                <Table.Row key={mob.mob}>
                  <Table.Cell>
                    {mob.name}
                  </Table.Cell>
                  <Table.Cell textAlign="right">
                    <Button
                      content="Retrieve Items"
                      disabled={!data.can_reclaim}
                      onClick={() => act('release_items', {
                        mobref: mob.mob,
                      })} />
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
