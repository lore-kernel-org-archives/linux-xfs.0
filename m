Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 29 Jul 2006 16:37:58 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6TNbKDW024027
	for <xfs@oss.sgi.com>; Sat, 29 Jul 2006 16:37:32 -0700
Message-ID: <44CBE0F5.3050201@melbourne.sgi.com>
Date: Sun, 30 Jul 2006 08:28:05 +1000
From: David Chatterton <chatz@melbourne.sgi.com>
Reply-To: chatz@melbourne.sgi.com
MIME-Version: 1.0
Subject: Re: XFS breakage in 2.6.18-rc1
References: <20060718222941.GA3801@stargate.galaxy> <20060719085731.C1935136@wobbly.melbourne.sgi.com> <Pine.LNX.4.64.0607221722500.8407@prinz64.housecafe.de> <20060724090138.C2083275@wobbly.melbourne.sgi.com> <Pine.LNX.4.64.0607281526220.1882@sheep.housecafe.de> <20060729074803.A2222647@wobbly.melbourne.sgi.com> <20060729202223.GD20039@charite.de>
In-Reply-To: <20060729202223.GD20039@charite.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>, Christian Kujau <evil@g-house.de>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com



Ralf Hildebrandt wrote:
> * Nathan Scott <nathans@sgi.com>:
> 
>> Barry sent an xfs_repair patch to resolve this issue to the xfs@oss.sgi.com
>> list yesterday; please give that a go and let us know how it fares.
> 
> Just to let you know, I did a cvs checkout of xfs-cmds
> as described on http://oss.sgi.com/projects/xfs/source.html
> 
> Then I saved the patch from
> http://oss.sgi.com/archives/xfs/2006-07/msg00374.html using the
> "Original" link on hat page.
> 
> I build a xfs_Repair binary using that, transferred it onto an old
> KLAX boot cd I had and repaired the XFS root on my laptop.
> 
> I got 5000 files in lost and found, mostly the whole manpages from my
> system. Had to reinstall a few packages to restore lost binaries, but
> that's all.
> 
> When will that horrible bug be fixed in 2.6.x? 
> 

The bug is fixed in 2.6.17.7.

David
