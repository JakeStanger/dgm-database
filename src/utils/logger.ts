import { createLogger, format, transports } from 'winston';
import 'winston-daily-rotate-file';

type LogLevel = 'debug' | 'info' | 'warn' | 'error';

const loggerFormat = format.printf(({ level, message, label, timestamp }) => {
  return `${timestamp} [${label}] ${level}: ${message}`;
});

const logger = createLogger({
  level: 'info',
  format: format.combine(format.timestamp(), loggerFormat),
  transports: [
    new transports.DailyRotateFile({
      filename: 'logs/error-%DATE%.log',
      level: 'error',
    }),
    new transports.DailyRotateFile({ filename: 'logs/combined-%DATE%-.log' }),
  ],
});

if (process.env.NODE_ENV !== 'production') {
  logger.add(
    new transports.Console({
      format: format.combine(
        format.colorize(),
        format.timestamp(),
        loggerFormat
      ),
    })
  );
}

export function log(
  label: string | InstanceType<any> | { new (): any },
  message: string,
  level?: LogLevel
) {
  if (typeof label !== 'string') {
    label = label.name ?? label.constructor.name;
  }

  logger.log({
    level: level ?? 'info',
    label,
    message,
  });
}

export function debug(label: string | InstanceType<any>, message: string) {
  log(label, message, 'debug');
}

export function info(label: string | InstanceType<any>, message: string) {
  log(label, message, 'info');
}

export function warn(label: string | InstanceType<any>, message: string) {
  log(label, message, 'warn');
}

export function error(label: string | InstanceType<any>, message: string) {
  log(label, message, 'error');
}
