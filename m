Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5AC5D7F6F
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 11:19:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 488808F8064
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 09:19:14 -0700 (PDT)
Received: from srv2.trombetti.net (srv2.trombetti.net [65.254.53.252]) by
	cuda.sgi.com with ESMTP id vnZbOPp33xW1LKzJ for
	<xfs@oss.sgi.com>; Tue, 28 Oct 2014 09:19:13 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested) (Authenticated sender: SASL)
	by srv2.trombetti.net (Postfix) with ESMTPSA id 7AB9C3135C
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 12:34:09 -0400 (EDT)
Message-ID: <544FC202.1000200@shiftmail.org>
Date: Tue, 28 Oct 2014 17:19:14 +0100
From: Spelic <spelic@shiftmail.org>
MIME-Version: 1.0
Subject: XFS shrinking planned?
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

Hello all,
XFS is such a good high performance filesystem, kudos for that.

However for large filesystems (which are mainly those that require high 
performance) the ability to shrink would be really needed. People 
usually do not have double the space so to move files to a smaller XFS 
filesystem, and the inability of XFS to shrink forbids major 
reorganizations of the storage systems.

Currently, for that reason I use ext4. Performance is still decent and 
flexibility is higher due to the ability to shrink, but I would use XFS 
if it could shrink.

I suppose shrinking ability is not even planned, is it?

Thank you
S.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
