Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 992347F37
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 10:11:59 -0500 (CDT)
Received: from xmail.sgi.com (pv-excas3-dc21.corp.sgi.com [137.38.106.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 87A158F8039
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 08:11:56 -0700 (PDT)
Message-ID: <521E133B.9050005@sgi.com>
Date: Wed, 28 Aug 2013 10:11:55 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_io: v8 add the lseek() SEEK_DATA/SEEK_HOLE support
References: <20130823174827.282748719@sgi.com>
In-Reply-To: <20130823174827.282748719@sgi.com>
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

Thanks for the patch Mark it has been committed.

Thanks
--Rich

commit b169249b1257d2a127484896a4a4ab2faf17f747
Author: Mark Tinguely <tinguely@sgi.com>
Date:   Fri Aug 23 17:48:23 2013 +0000

     xfs_io: v8 add the lseek() SEEK_DATA/SEEK_HOLE support

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
