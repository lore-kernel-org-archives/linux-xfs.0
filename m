Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Jul 2006 12:17:31 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [66.45.37.187])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6NJHHDW019764
	for <xfs@oss.sgi.com>; Sun, 23 Jul 2006 12:17:17 -0700
Received: from localhost (localhost [127.0.0.1])
	by lucidpixels.com (Postfix) with ESMTP id 4964216172ECC
	for <xfs@oss.sgi.com>; Sun, 23 Jul 2006 15:16:48 -0400 (EDT)
Date: Sun, 23 Jul 2006 15:16:48 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: chattr +d dir
Message-ID: <Pine.LNX.4.64.0607231515530.30844@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I used the chattr +d option for no_dump for a certain directory, but it 
still appears xfsdump dumped the directory anyway?

Is there some special usage/way to make xfsdump NOT dump a certain 
directory?

Justin.
