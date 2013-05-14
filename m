Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C2E3E7F3F
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 08:14:28 -0500 (CDT)
Message-ID: <519238CE.4090008@sgi.com>
Date: Tue, 14 May 2013 08:14:54 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V4] xfstests: make install support common/ and tests/ dirs
References: <20130503173918.138615197@cxfsxe4.americas.sgi.com>
In-Reply-To: <20130503173918.138615197@cxfsxe4.americas.sgi.com>
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
To: xfs@oss.sgi.com
Cc: Wang Sheng-Hui <shhuiw@gmail.com>

This patch has been committed:

commit e894cb079a81ff17dcdbe0977ad224a6bbe37dfc
Author: Wang Sheng-Hui <shhuiw@gmail.com>
Date:   Mon May 13 15:41:21 2013 -0500

     xfstests: update method to set TESTS_SUBDIRS in tests/Makefile.

       make install support common/ and tests/ dirs (V4)
       * reposted for current top of tree changes. [rjohnston@sgi.com]
       * use the neater way by Dave to get the TESTS_SUBDIRS in 
tests/Makefile.

Thanks
--Rich

On 05/03/2013 12:39 PM, rjohnston@sgi.com wrote:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
