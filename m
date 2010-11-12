Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oACJDcuN152474 for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 13:13:40 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87B101746D5
	for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 11:09:55 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UPrtoUqBphPJxfI0 for
	<xfs@oss.sgi.com>; Fri, 12 Nov 2010 11:09:55 -0800 (PST)
Message-ID: <4CDD90FF.5070304@sandeen.net>
Date: Fri, 12 Nov 2010 13:09:51 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Testcase and guide to XFS log corruption issues.
References: <AANLkTinsus+r4p6122hZwHupoQ7sXimGTpnwiTYmKVKC@mail.gmail.com>
In-Reply-To: <AANLkTinsus+r4p6122hZwHupoQ7sXimGTpnwiTYmKVKC@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: xfs@oss.sgi.com

On 11/10/2010 11:35 PM, Ajeet Yadav wrote:
> If there is already a procedure or tool to check these issues then I
> will be glad if you can share you knowledge with us.

Running xfstests would be a fine place to start.
There are tests in there which test log replay.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
