Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 10:08:31 -0700 (PDT)
Received: from web32908.mail.mud.yahoo.com (web32908.mail.mud.yahoo.com [209.191.69.108])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l8QH8Qdl025458
	for <linux-xfs@oss.sgi.com>; Wed, 26 Sep 2007 10:08:28 -0700
Date: Wed, 26 Sep 2007 10:08:25 -0700 (PDT)
From: "Bryan J. Smith" <thebs413@yahoo.com>
Reply-To: b.j.smith@ieee.org
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
In-Reply-To: <20070926151534.GD30287@p15145560.pureserver.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <696865.53046.qm@web32908.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ralf Gross <Ralf-Lists@ralfgross.de>, linux-xfs@oss.sgi.com

Ralf Gross <Ralf-Lists@ralfgross.de> wrote:
> You're right, but these benchmarks help to find simple failures or
> misconfigurations at an earlier stage of the process.

Yes, as long as you are comparing to a benchmark of a known, similar
quantity.

It's not uncommon for Linux's RAID-5 to be 2-3x faster at dd and
single file operations, especially if there are no, actual parity
operations.


-- 
Bryan J. Smith   Professional, Technical Annoyance
b.j.smith@ieee.org    http://thebs413.blogspot.com
--------------------------------------------------
     Fission Power:  An Inconvenient Solution
