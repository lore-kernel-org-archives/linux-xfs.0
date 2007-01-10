Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 10 Jan 2007 15:05:49 -0800 (PST)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0AN5gqw021828
	for <linux-xfs@OSS.SGI.com>; Wed, 10 Jan 2007 15:05:44 -0800
Received: from from [127.0.0.1] (helo=base.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.62 #1)
	id 1H4m6L-0004ta-Ap
	for <linux-xfs@OSS.SGI.com>; Wed, 10 Jan 2007 22:39:21 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17829.27416.823078.9589@base.ty.sabi.co.UK>
Date: Wed, 10 Jan 2007 22:39:20 +0000
Subject: Re: Mounting an external HDD fails each second time after xfs_repair
In-Reply-To: <eo2q35$h6e$1@sea.gmane.org>
References: <eo2q35$h6e$1@sea.gmane.org>
From: pg_xfs@xfs.to.sabi.co.UK (Peter Grandi)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <linux-xfs@oss.sgi.com>

>>> On Wed, 10 Jan 2007 14:35:34 +0100, Christoph Bier
>>> <christoph.bier@web.de> said:

christoph.bier> Hi all, I use 14 partitions (one extended
christoph.bier> partition; partition table see below) on my new
christoph.bier> external 400GB HDD that is managed by LVM2 on
christoph.bier> Debian Sarge with a vanilla kernel 2.6.19.

Fascinating setup :-).

We can of course assume, given the care with which you have
designed your setup, and the astuteness of your choice to omit
any details as to the hardware (what type of HD interface, what
type of external bus, the bridge and the host adapter chipsets,
the disk and the power supply ratings) that you have advisedly
chosen the external disk for 100% reliable operation, as you
have checked thoroughly that the power supply of the case is
sufficient and that both chipsets (USB? FW?) are well known for
being bug-free and reliable for use with the relevant GNU/Linux
mass storage driver... :-)

christoph.bier> The first time I mounted the HDD on my desktop
christoph.bier> everything worked fine [ ... ]

A typo here: you typed "worked fine" instead of "seemed to work
fine".
