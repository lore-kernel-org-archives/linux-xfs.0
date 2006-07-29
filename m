Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 29 Jul 2006 13:23:23 -0700 (PDT)
Received: from mail.charite.de (mail.charite.de [160.45.207.131])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6TKMtDW026332
	for <xfs@oss.sgi.com>; Sat, 29 Jul 2006 13:22:56 -0700
Date: Sat, 29 Jul 2006 22:22:24 +0200
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
Subject: Re: XFS breakage in 2.6.18-rc1
Message-ID: <20060729202223.GD20039@charite.de>
References: <20060718222941.GA3801@stargate.galaxy> <20060719085731.C1935136@wobbly.melbourne.sgi.com> <Pine.LNX.4.64.0607221722500.8407@prinz64.housecafe.de> <20060724090138.C2083275@wobbly.melbourne.sgi.com> <Pine.LNX.4.64.0607281526220.1882@sheep.housecafe.de> <20060729074803.A2222647@wobbly.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20060729074803.A2222647@wobbly.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: Christian Kujau <evil@g-house.de>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

* Nathan Scott <nathans@sgi.com>:

> Barry sent an xfs_repair patch to resolve this issue to the xfs@oss.sgi.com
> list yesterday; please give that a go and let us know how it fares.

Just to let you know, I did a cvs checkout of xfs-cmds
as described on http://oss.sgi.com/projects/xfs/source.html

Then I saved the patch from
http://oss.sgi.com/archives/xfs/2006-07/msg00374.html using the
"Original" link on hat page.

I build a xfs_Repair binary using that, transferred it onto an old
KLAX boot cd I had and repaired the XFS root on my laptop.

I got 5000 files in lost and found, mostly the whole manpages from my
system. Had to reinstall a few packages to restore lost binaries, but
that's all.

When will that horrible bug be fixed in 2.6.x? 

-- 
Ralf Hildebrandt (i.A. des IT-Zentrums)         Ralf.Hildebrandt@charite.de
Charite - Universitätsmedizin Berlin            Tel.  +49 (0)30-450 570-155
Gemeinsame Einrichtung von FU- und HU-Berlin    Fax.  +49 (0)30-450 570-962
IT-Zentrum Standort CBF                 send no mail to spamtrap@charite.de
