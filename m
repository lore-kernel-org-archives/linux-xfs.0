Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3JLFTEU053927 for <xfs@oss.sgi.com>; Tue, 19 Apr 2011 16:15:29 -0500
Received: from ifup.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CDCB01EC0F2F
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2011 14:18:55 -0700 (PDT)
Received: from ifup.org (ifup.org [198.145.64.140]) by cuda.sgi.com with ESMTP
	id veoh4ldbxVRKrQBM for <xfs@oss.sgi.com>;
	Tue, 19 Apr 2011 14:18:55 -0700 (PDT)
Date: Tue, 19 Apr 2011 14:15:46 -0700
From: Brandon Philips <brandon@ifup.org>
Subject: [ANNOUNCE] acl: 2.2.51 release
Message-ID: <20110419211546.GC4133@hanuman.home.ifup.org>
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

acl 2.2.51 is released. This release fixes a few make tests issues that
were found. You can find it here:

 http://download.savannah.gnu.org/releases/acl/acl-2.2.51.src.tar.gz
 (NOTE: not all mirrors are synced)

The git repo is here and the tag is v2.2.51:
 http://git.savannah.gnu.org/cgit/acl.git/

Here comes the shortlog:

Brandon Philips (3):
      test/misc.test: rm f from the top of the test
      test: Makefile remove directory prefix from malformed-restore-double-owner.acl
      VERSION: v2.2.50 -> v2.2.51

Thanks to Kamil for pointing out make test failures.

Cheers,

	Brandon

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
