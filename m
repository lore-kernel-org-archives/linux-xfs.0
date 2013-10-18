Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2232A7F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 11:35:57 -0500 (CDT)
Message-ID: <52616369.8040907@sgi.com>
Date: Fri, 18 Oct 2013 11:35:53 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: fix potential memory leak in repare/sb.c
References: <1379497242.5874.7.camel@ThinkPad-T5421>
In-Reply-To: <1379497242.5874.7.camel@ThinkPad-T5421>
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
To: Li Zhong <zhong@linux.vnet.ibm.com>, xfsprogs <xfs@oss.sgi.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

This has been committed.

Thanks
--Rich

commit 70ee4153f4c998774adcee1e576d3c1f305b92d0
Author: Li Zhong <zhong@linux.vnet.ibm.com>
Date:   Wed Sep 18 09:40:42 2013 +0000

     xfsprogs: fix potential memory leak in repare/sb.c

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
