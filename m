Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 536EB7F3F
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 17:52:33 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 466F18F8081
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 15:52:32 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id DlVTLLwWGR0F7K42 for <xfs@oss.sgi.com>;
	Tue, 18 Feb 2014 15:52:31 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/9] current series for verifier error differentiation
Date: Tue, 18 Feb 2014 17:52:20 -0600
Message-Id: <1392767549-25574-1-git-send-email-sandeen@redhat.com>
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

This is the current series I have leading up to verifier error differentiation,
just resending them all.

As I send this, I remember that EILSEQ is giving us an unusual perror()
output, so the last patch which uses it may need to pick some (?)
other error code...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
