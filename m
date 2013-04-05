Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3F8CA29E1A
	for <xfs@oss.sgi.com>; Fri,  5 Apr 2013 09:54:10 -0500 (CDT)
Message-ID: <515EE5A5.7070608@sgi.com>
Date: Fri, 5 Apr 2013 09:54:29 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add _require_seek_data_hole to check seek
	data/hole
References: <1364289252-7012-1-git-send-email-wenqing.lz@taobao.com>
In-Reply-To: <1364289252-7012-1-git-send-email-wenqing.lz@taobao.com>
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
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, xfs@oss.sgi.com

Looks reasonable, will you please rework this for TOT changes?

tests 285 and 286 are now in the tests/generic directory and
common.rc is now common/rc

Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
