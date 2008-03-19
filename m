Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Mar 2008 07:11:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2JEBBVt011705
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 07:11:12 -0700
Received: from ventoso.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B65BDFCF43A
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 07:11:44 -0700 (PDT)
Received: from ventoso.org (61.pool85-52-226.static.orange.es [85.52.226.61]) by cuda.sgi.com with ESMTP id pGQiOxCDGn209oQJ for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 07:11:44 -0700 (PDT)
Received: from [127.0.0.1] (localhost.localdomain [127.0.0.1])
	by ventoso.org (Postfix) with ESMTP id 3C5ABC1FA29
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 15:11:11 +0100 (CET)
Message-ID: <47E11EFD.3090705@ventoso.org>
Date: Wed, 19 Mar 2008 15:11:09 +0100
From: Luca Olivetti <luca@ventoso.org>
MIME-Version: 1.0
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
References: <b1b17e290803181649w507322e7mf1410b30a2621506@mail.gmail.com> <20080319002307.GA11349@josefsipek.net> <47E0F746.1090508@ventoso.org> <47E10CBA.9020904@sandeen.net>
In-Reply-To: <47E10CBA.9020904@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

En/na Eric Sandeen ha escrit:

>> However, any later kernel I tried "breaks" xfs (that's why I originally 
>> subscribed to this list), i.e. I cannot see the contents of some directories
>> (more details here: 
>> http://buffalo.nas-central.org/forums/viewtopic.php?p=35061#p35061)
> 
> do you still have that small fs image?  I'll take a look.  There was
> also an arm get_unaligned issue which hit xfs in another spot,
> http://marc.info/?l=git-commits-head&m=120433318323826&w=3

Sure, I'll send you privately a link

> might be worth seeing if you still have trouble with that fix in place
> (which is slated for 2.6.25)

It's not that easy for me to test, since the linkstation is my home 
server :-(

Bye
-- 
Luca
