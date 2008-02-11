Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 10 Feb 2008 16:17:32 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1B0HLfv023561
	for <xfs@oss.sgi.com>; Sun, 10 Feb 2008 16:17:23 -0800
Date: Mon, 11 Feb 2008 11:17:28 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Possible fix for 2.6.24 xfs_file_readdir crash
Message-ID: <20080211001727.GO155407@sgi.com>
References: <20080205052418.GU155259@sgi.com> <20080209120423.GA6699@diesel.geggus.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080209120423.GA6699@diesel.geggus.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sven Geggus <lists@fuchsschwanzdomain.de>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, Tobias Ulmer <tu@emlix.com>, Andrea Perotti <andreamtp@goodfellow.it>

On Sat, Feb 09, 2008 at 01:04:24PM +0100, Sven Geggus wrote:
> David Chinner schrieb am Dienstag, den 05. Februar um 06:24 Uhr:
> 
> > Can you try the patch attached below
> 
> Am I correct in the assumption, that this did not make it into
> 2.6.24.1?

Right - the fix wasn't in Linus' kernel by the time 2.6.24.1 was
released.

> Can we reckon that this patch will get included in one of the next
> minor releases?

Already queued for 2.6.24.2.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
