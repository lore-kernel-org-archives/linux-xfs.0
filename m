Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 80B3B7CA0
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 16:15:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EAD60AC003
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 14:15:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 3tpjzErGWM54aI5J for <xfs@oss.sgi.com>;
	Tue, 19 Jul 2016 14:15:05 -0700 (PDT)
Received: from Liberator.local (204-195-32-108.wavecable.com [204.195.32.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128
	bits)) (No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 2147C4A4
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 16:15:04 -0500 (CDT)
Subject: Re: [PATCH] xfs: Document error handling behavior
References: <1468922657-3895-1-git-send-email-cmaiolino@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <94b928aa-70f7-dbf4-66a8-a5f6ca2a4944@sandeen.net>
Date: Tue, 19 Jul 2016 14:15:03 -0700
MIME-Version: 1.0
In-Reply-To: <1468922657-3895-1-git-send-email-cmaiolino@redhat.com>
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
To: xfs@oss.sgi.com

On 7/19/16 3:04 AM, Carlos Maiolino wrote:
> This is the first try to document the implementation of error handlers into
> sysfs.
> 
> Reviews and comments are appreciated, please also notice I'm not english-native,
> so, spelling corrections are also appreciated :)

Thanks for doing this! 

There seems to be a specific sysfs documentation format, see for example
Documentation/ABI/testing/sysfs-fs-ext4 

It might be better to follow that format, and refer to it after a brief
explanation of the functionality in the xfs.txt file?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
