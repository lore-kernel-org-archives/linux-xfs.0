Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 May 2008 05:38:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4KCcENV015654
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 05:38:14 -0700
Received: from smtp8-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 49A051192612
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 05:39:03 -0700 (PDT)
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65]) by cuda.sgi.com with ESMTP id If5H5aavY7e7gXJR for <xfs@oss.sgi.com>; Tue, 20 May 2008 05:39:03 -0700 (PDT)
Date: Tue, 20 May 2008 14:39:06 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS filesystem reports as full though it isn't
Message-ID: <20080520143906.4e96426c@harpe.intellique.com>
In-Reply-To: <20080520101918.GA24579@infradead.org>
References: <20080516222755.3e557c00@galadriel.home>
	<20080518131855.GA1383@infradead.org>
	<20080518132127.GA19006@infradead.org>
	<20080518154208.77b6be3e@galadriel.home>
	<20080519221057.75e0a775@galadriel.home>
	<20080520101918.GA24579@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Le Tue, 20 May 2008 06:19:18 -0400
Christoph Hellwig <hch@infradead.org> écrivait:

> I've submitted a patch that should give back an error when remounting
> with an option not supported in remount, that should fix this little
> oversight in the future.  Thanks for the report!

Thanks for the patch :)

-- 
----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------
