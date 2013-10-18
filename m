Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 96E327F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 12:20:01 -0500 (CDT)
Message-ID: <52616DBE.8020102@sgi.com>
Date: Fri, 18 Oct 2013 12:19:58 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: fix crc32 build on big endian
References: <524F7753.8050801@redhat.com>
In-Reply-To: <524F7753.8050801@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

This has been committed.

Thanks
--Rich

commit b2dbd6a9a2df5099882bdfc068caa76cf334c99a
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Sat Oct 5 02:20:03 2013 +0000

     xfsprogs: fix crc32 build on big endian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
