Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 27 May 2008 14:17:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4RLHbdo014229
	for <xfs@oss.sgi.com>; Tue, 27 May 2008 14:17:37 -0700
Received: from proxy3.bredband.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 49E431BEAAB
	for <xfs@oss.sgi.com>; Tue, 27 May 2008 14:18:28 -0700 (PDT)
Received: from proxy3.bredband.net (proxy3.bredband.net [195.54.101.73]) by cuda.sgi.com with ESMTP id Yt8HJcCY0lfKnByG for <xfs@oss.sgi.com>; Tue, 27 May 2008 14:18:28 -0700 (PDT)
Received: from ironport2.bredband.com (195.54.101.122) by proxy3.bredband.net (7.3.127)
        id 481183EA009CE9EF for xfs@oss.sgi.com; Tue, 27 May 2008 23:18:26 +0200
Message-ID: <483C7A9B.1010401@stesmi.com>
Date: Tue, 27 May 2008 23:18:19 +0200
From: Stefan Smietanowski <stesmi@stesmi.com>
MIME-Version: 1.0
Subject: Re: xfs_repair getting stuck
References: <ebe74d2a0805271335x5844239eje2eeed606d7cc8b8@mail.gmail.com>
In-Reply-To: <ebe74d2a0805271335x5844239eje2eeed606d7cc8b8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sebastian M <sebcio@gmail.com>
Cc: xfs@oss.sgi.com

Sebastian M wrote:
> Hello
> 
> I was a happy user of the XFS untill yesterday. I had to move data off
> the XFS partition
> to other storage. I exported it via NFS.
> After half a day of moving files a kernel panic appeared on nfs server.
> (sorry, but currently I don't have any logs). After reboot I wasn't able to
> mount XFS partition anymore (got random kernel panics). I've tried to
> xfs_repair, however it didn't work out. I had to use -L option.
> As for now I can mount the partition, but most of my folders are not accessible:

I'm guessing you've checked that the raid array is fit for fight?
Just so that the problem doesn't end up being the array itself.

// Stefan
