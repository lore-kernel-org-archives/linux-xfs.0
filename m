Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 04 Jun 2008 08:05:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m54F5tOQ009142
	for <xfs@oss.sgi.com>; Wed, 4 Jun 2008 08:05:55 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 69D3F11B76DD
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2008 08:06:49 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 2miyFXGNzRNsP3BK for <xfs@oss.sgi.com>; Wed, 04 Jun 2008 08:06:49 -0700 (PDT)
Message-ID: <4846AF87.8010307@sandeen.net>
Date: Wed, 04 Jun 2008 10:06:47 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Questions for article
References: <13033.143.166.226.57.1212526129.squirrel@tomslinux.homelinux.org>    <20080604053156.GB6509@infradead.org> <32954.143.166.226.42.1212588962.squirrel@tomslinux.homelinux.org>
In-Reply-To: <32954.143.166.226.42.1212588962.squirrel@tomslinux.homelinux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Thomas King <kingttx@tomslinux.homelinux.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Thomas King wrote:
>> On Tue, Jun 03, 2008 at 03:48:49PM -0500, Thomas King wrote:
>>> For the most part, XFS is used for massive filesystems (hundreds of petabytes)
>> I think undreds of petabytes is not something we commonly see today :)
>> hundreds of TB is more reasonable.
> 
> If I'm going to answer his two articles, he's speaking in the context of massive
> filesystems. True, hundreds of petabytes are not common but that's the
> environment he's talking about.
> 
> From what I'm seeing from XFS, BTRFS, ext4, and HAMMER, Linux filesystems are
> going to easily keep up with the current trend. For the massive filesystems
> Henry speaks of, XFS has some new features I don't think he's aware of and needs
> to come out in this answer.
> 
> Tom King

One thing I would be careful of is not to fall into the trap of letting
Linux filesystems get bashed over things that *nobody* really has today.
 Stuff like PNFS, OSD, DIF etc are bleeding-edge for almost *everybody*

Petabyte filesystems are hard.  For *everybody*

And hundred-petabyte filesystems aren't just uncommon, they don't exist
AFAIK.

-Eric
