Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 18 May 2008 06:41:40 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4IDfb1s001981
	for <xfs@oss.sgi.com>; Sun, 18 May 2008 06:41:37 -0700
Received: from smtp7-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 81A6A790405
	for <xfs@oss.sgi.com>; Sun, 18 May 2008 06:42:25 -0700 (PDT)
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64]) by cuda.sgi.com with ESMTP id tI99b3k4vHjEq3VP for <xfs@oss.sgi.com>; Sun, 18 May 2008 06:42:25 -0700 (PDT)
Date: Sun, 18 May 2008 15:42:08 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS filesystem reports as full though it isn't
Message-ID: <20080518154208.77b6be3e@galadriel.home>
In-Reply-To: <20080518132127.GA19006@infradead.org>
References: <20080516222755.3e557c00@galadriel.home>
	<20080518131855.GA1383@infradead.org>
	<20080518132127.GA19006@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Le Sun, 18 May 2008 09:21:27 -0400 vous écriviez:

> > Did you remount it with that option as in mount -o remount or did
> > you completely unmount it and mount it again?  Unfortunately none
> > of the xfs-specific mount options can be reset with remount yet,
> > and it doesn't return an error either (both are added to my todo
> > list now)  
> 

IIRC I tried both, however I'll double check monday...

> Oh, and please post the output of /proc/self/mounts to see if all
> expected mount options are actualy seen by the filesystem.

OK, thanks.

-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------
