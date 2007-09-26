Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 10:13:16 -0700 (PDT)
Received: from web32913.mail.mud.yahoo.com (web32913.mail.mud.yahoo.com [209.191.69.113])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l8QHD94Q026622
	for <linux-xfs@oss.sgi.com>; Wed, 26 Sep 2007 10:13:11 -0700
Date: Wed, 26 Sep 2007 10:13:08 -0700 (PDT)
From: "Bryan J. Smith" <thebs413@yahoo.com>
Reply-To: b.j.smith@ieee.org
Subject: Re: [UNSURE] Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
In-Reply-To: <20070926165412.GE30287@p15145560.pureserver.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <295084.46754.qm@web32913.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ralf Gross <Ralf-Lists@ralfgross.de>, linux-xfs@oss.sgi.com

Ralf Gross <Ralf-Lists@ralfgross.de> wrote:
> Still 170-200 MB/s. The command above just tunes the read ahead
> value.

Don't expect your commits to an external subsystem to be anywhere
near as fast as software RAID in simple disk benchmarks.


-- 
Bryan J. Smith   Professional, Technical Annoyance
b.j.smith@ieee.org    http://thebs413.blogspot.com
--------------------------------------------------
     Fission Power:  An Inconvenient Solution
