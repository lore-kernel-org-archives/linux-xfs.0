Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3JLFTih053929 for <xfs@oss.sgi.com>; Tue, 19 Apr 2011 16:15:29 -0500
Received: from ifup.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3052E3F8E9A
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2011 14:18:56 -0700 (PDT)
Received: from ifup.org (ifup.org [198.145.64.140]) by cuda.sgi.com with ESMTP
	id F3F2kPZEc21KwCXD for <xfs@oss.sgi.com>;
	Tue, 19 Apr 2011 14:18:56 -0700 (PDT)
Date: Tue, 19 Apr 2011 14:16:54 -0700
From: Brandon Philips <brandon@ifup.org>
Subject: [ANNOUNCE] attr: 2.4.46 release
Message-ID: <20110419211654.GD4133@hanuman.home.ifup.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: acl-devel@nongnu.org
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Hello-

attr 2.4.46 is released. This release fixes a few make tests problems
that were found. You can find it here:

 http://download.savannah.gnu.org/releases/attr/attr-2.4.46.src.tar.gz

The git repo is here and the tag is v2.4.46:
 http://git.savannah.gnu.org/cgit/attr.git/

Here comes the shortlog:

Brandon Philips (3):
      test: Add sort-getfattr-output to source files
      test: fix root tests with sorting
      VERSION: 2.4.45 -> 2.4.46

Cheers,

	Brandon

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
