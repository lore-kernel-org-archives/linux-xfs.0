Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DAB3F7F85
	for <xfs@oss.sgi.com>; Fri, 29 Mar 2013 10:13:40 -0500 (CDT)
Message-ID: <5155AFAC.5000709@sgi.com>
Date: Fri, 29 Mar 2013 10:13:48 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: fix common source file path
References: <1364532595-21273-1-git-send-email-eguan@redhat.com>
In-Reply-To: <1364532595-21273-1-git-send-email-eguan@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

Eryu,

Thanks for submitting this patch, it has been submitted.

--Rich

commit 8575764a791b83471f4588e12d5245651007bfc5
Author: Eryu Guan <eguan@redhat.com>
Date:   Fri Mar 29 04:49:55 2013 +0000

     xfstests: fix common source file path

     After the re-factor, common.* have been renamed to common/* but there
     are several files still look for the old path, fix it.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
