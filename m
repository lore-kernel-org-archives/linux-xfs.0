Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BDF6E8034
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 10:59:31 -0500 (CDT)
Message-ID: <5143457A.6060303@sgi.com>
Date: Fri, 15 Mar 2013 10:59:54 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfstests: test writing to device node on an RO
	filesystem
References: <514243C0.1000309@redhat.com> <5142896E.9060609@sandeen.net>
In-Reply-To: <5142896E.9060609@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Eric,

Thanks again for the new test. A few minor issues that can be corrected 
at commit time.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

I can correct this a commit time.

quilt refresh
Warning: trailing whitespace in line 24 of 306
Refreshed patch 
patches/V2-xfstests-test-writing-to-device-node-on-an-RO-filesystem.patch

Do you also want me to add this top the quick group as Dave suggested 
when I commit this?

Thanks
--Rich



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
