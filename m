Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7E32A7F50
	for <xfs@oss.sgi.com>; Sat,  5 Oct 2013 21:57:02 -0500 (CDT)
Received: from eagdhcp-232-165.americas.sgi.com
	(eagdhcp-232-165.americas.sgi.com [128.162.232.165])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 00511AC003
	for <xfs@oss.sgi.com>; Sat,  5 Oct 2013 19:57:01 -0700 (PDT)
Received: from eagdhcp-232-165.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-165.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r962v1bG002595
	for <xfs@oss.sgi.com>; Sat, 5 Oct 2013 21:57:01 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-165.americas.sgi.com)
Message-Id: <20131006025151.573856006@sgi.com>
Date: Sat, 05 Oct 2013 21:51:51 -0500
From: tinguely@sgi.com
Subject: [PATCH 0/2] xfsprogs misc memory leaks
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Here are the xfsprog versions of the Coverity 134683 and 134681 found
leak patches. They are the same as the kernel except the file names.

--Mark.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
