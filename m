Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A87B67F50
	for <xfs@oss.sgi.com>; Sat,  2 Feb 2013 14:46:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8E8A5304039
	for <xfs@oss.sgi.com>; Sat,  2 Feb 2013 12:46:03 -0800 (PST)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id CHG1fbA1KDOtBHVw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 02 Feb 2013 12:46:02 -0800 (PST)
Date: Sat, 2 Feb 2013 21:46:01 +0100
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: xfs deadlock on buffer semaphore while reading directory
Message-ID: <20130202204601.GT30577@one.firstfloor.org>
References: <20130202192007.GS30577@one.firstfloor.org>
	<510D6EDE.1080409@sgi.com>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <510D6EDE.1080409@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, xfs@oss.sgi.com

> That looks like a hang fixed by the series:
> 
> 	http://oss.sgi.com/archives/xfs/2012-12/msg00071.html

Great that it is already fixed. Thanks.

Is the fix considered for stable?

-Andi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
