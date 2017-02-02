Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.webx.cz ([109.123.222.201]:47602 "EHLO mail.webx.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750881AbdBBIfi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Feb 2017 03:35:38 -0500
From: Libor =?utf-8?B?S2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Subject: Re: [PATCH] xfs_repair: junk leaf attribute if count == 0
Date: Thu, 02 Feb 2017 09:35:34 +0100
Message-ID: <371530044.aY76b0UHp3@libor-nb>
In-Reply-To: <8a918652-f073-6c6e-0926-5a3b3f02e691@sandeen.net>
References: <725190d9-6db0-4f6c-628b-76f2dca3071f@redhat.com> <3965431.22NzgsWbJj@libor-nb> <8a918652-f073-6c6e-0926-5a3b3f02e691@sandeen.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Hi,

On středa 1. února 2017 16:49:49 CET Eric Sandeen wrote:
> On 2/1/17 6:48 AM, Libor Klepáč wrote:
> > Hello,
> > we tried also on vps1 reported here in bottom of email
> > https://www.spinics.net/lists/linux-xfs/msg01728.html
> > and vps3 from this email
> > https://www.spinics.net/lists/linux-xfs/msg02672.html
> > 
> > Both came clean. Does it mean, that corruption was really only in memory 
> > and did not made it to disks?
> 
> The point of the xfs_repair patch was to fix the problem
> on-disk.
Yes, i understand that

> 
> I'm not sure what steps your machines have been through, so I
> can't really speak to their situation, but assuming the repairs
> below were with the patch in place, it appears that they are
> clean now.
> 
Ok, seems fair ;)

> -Eric

Thanks,
Libor

