Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 57CA77F62
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 09:39:18 -0600 (CST)
Received: from gulag1.americas.sgi.com (gulag1.americas.sgi.com
	[128.162.236.41])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 321DC8F8039
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 07:39:15 -0800 (PST)
Message-Id: <20130129153914.801475275@sgi.com>
Date: Tue, 29 Jan 2013 09:39:14 -0600
From: rjohnston@sgi.com
Subject: [PATCH 0/3] Add agskip=value mount option
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

This series will:

    1. Add agskip=value mount option to xfs
    2. Add agkip mount option test to xfstests
    3. Add agskip mount option to the mount.8 manpage (util-linux)

--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
