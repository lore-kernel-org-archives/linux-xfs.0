Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9RHp3L5070487
	for <linux-xfs@oss.sgi.com>; Tue, 27 Oct 2009 12:51:03 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9DD46AC004
	for <linux-xfs@oss.sgi.com>; Tue, 27 Oct 2009 10:52:38 -0700 (PDT)
Message-ID: <4AE73365.7070206@sgi.com>
Date: Tue, 27 Oct 2009 12:52:37 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: xfsrestore restoring MANY more files/dirs than expected, why?
References: <hc724t$tcn$1@ger.gmane.org> <4AE717CF.5020308@sgi.com>
	<hc79tr$t62$1@ger.gmane.org>
In-Reply-To: <hc79tr$t62$1@ger.gmane.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: mlueck@lueckdatasystems.com
Cc: linux-xfs@oss.sgi.com

On 10/27/2009 12:16 PM, Michael Lueck wrote:
> 
> How do I correctly invoke the -Q switch of xfsrestore? Various things I 
> have tried xfsrestore does not like the syntax of.

 From the sound of it, you could just wipe out the old state
directory ("xfsrestorehousekeepingdir") and start a fresh restore.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
