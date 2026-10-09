//! The options that are used to configure a terminal IO implementation.

const xev = @import("../global.zig").xev;
const apprt = @import("../apprt.zig");
const renderer = @import("../renderer.zig");
const Config = @import("../config.zig").Config;
const termio = @import("../termio.zig");

/// All size metrics for the terminal.
size: renderer.Size,

/// The full app configuration. This is only available during initialization.
/// The memory it points to is NOT stable after the init call so any values
/// in here must be copied.
full_config: *const Config,

/// The derived configuration for this termio implementation.
config: termio.Termio.DerivedConfig,

/// The backend for termio that implements where reads/writes are sourced.
backend: termio.Backend,

/// The mailbox for the terminal. This is how messages are delivered.
/// If you're using termio.Thread this MUST be "mailbox".
mailbox: termio.Mailbox,

/// The render state. The IO implementation can modify anything here. The
/// surface thread will setup the initial "terminal" pointer but the IO impl
/// is free to change that if that is useful (i.e. doing some sort of dual
/// terminal implementation.)
renderer_state: *renderer.State,

/// A handle to wake up the renderer. This hints to the renderer that
/// a repaint should happen.
renderer_wakeup: xev.Async,

/// The mailbox for renderer messages.
renderer_mailbox: *renderer.Thread.Mailbox,

/// The mailbox for sending the surface messages.
surface_mailbox: apprt.surface.Mailbox,

/// Immutable host support for OSC 7501 reports and lifecycle actions.
supports_program_status: bool = false,

/// Surface lifetime signal for status writers blocked on the UI mailbox.
program_status_closed: ?*const @import("std").atomic.Value(bool) = null,

/// Stable identity; queued reports must not follow a reused surface pointer.
program_status_surface_id: u64 = 0,
