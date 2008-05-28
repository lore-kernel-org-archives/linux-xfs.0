Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 28 May 2008 01:23:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4S8N3Ye010327
	for <xfs@oss.sgi.com>; Wed, 28 May 2008 01:23:03 -0700
Received: from smtp7-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 922EEBF872D
	for <xfs@oss.sgi.com>; Wed, 28 May 2008 01:23:53 -0700 (PDT)
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64]) by cuda.sgi.com with ESMTP id 6m98VQWy8agkRUOv for <xfs@oss.sgi.com>; Wed, 28 May 2008 01:23:53 -0700 (PDT)
Date: Wed, 28 May 2008 10:20:38 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: xfs_check
Message-ID: <20080528102038.768dfd93@galadriel.home>
In-Reply-To: <20080527162605.GA30344@lst.de>
References: <20080527162605.GA30344@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Le Tue, 27 May 2008 18:26:05 +0200 vous écriviez:

>  Is there any reason
> why we shouldn't simply kill xfs_check and replaced it with a wrapper
> around xfs_repair?

I may add that I hardly even had any filesystem recently small enough
to fit xfs_check hunger for memory. All attempts to use xfs_check
invariably ended with "out of memory" for 5 years or more. Actually
IIRC I  used xfs_check succesfully only on IRIX, back in the time of
9GB usrroot drives :)

-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------
