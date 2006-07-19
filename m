Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Jul 2006 02:13:52 -0700 (PDT)
Received: from smtp.nildram.co.uk (smtp.nildram.co.uk [195.112.4.54])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6J9DLDW032657
	for <xfs@oss.sgi.com>; Wed, 19 Jul 2006 02:13:22 -0700
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
Subject: Re: XFS breakage in 2.6.18-rc1
Date: Wed, 19 Jul 2006 09:08:30 +0100
References: <20060718222941.GA3801@stargate.galaxy> <20060719085731.C1935136@wobbly.melbourne.sgi.com>
In-Reply-To: <20060719085731.C1935136@wobbly.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200607190908.30727.s0348365@sms.ed.ac.uk>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: Torsten Landschoff <torsten@debian.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tuesday 18 July 2006 23:57, Nathan Scott wrote:
[snip]
> > of programs fail in mysterious ways. I tried to recover using xfs_repair
> > but I feel that my partition is thorougly borked. Of course no data was
> > lost due to backups but still I'd like this bug to be fixed ;-)
>
> 2.6.18-rc1 should be fine (contains the corruption fix).  Did you
> mkfs and restore?  Or at least get a full repair run?  If you did,
> and you still see issues in .18-rc1, please let me know asap.

Just out of interest, I've got a few XFS volumes that were created 24 months 
ago on a machine that I upgraded to 2.6.17 about a month ago. I haven't seen 
any crashes so far.

Assuming I get the newest XFS repair tools on there, what's the disadvantage 
of repairing versus creating a new filesystem? What special circumstances are 
required to cause a crash?

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
