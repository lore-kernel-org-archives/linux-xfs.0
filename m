Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C6ACD7F3F
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 10:48:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B61D98F8066
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 08:48:17 -0800 (PST)
Received: from ceres.bofanez.org (ceres.ord.bofanez.net [50.57.139.246]) by
	cuda.sgi.com with ESMTP id UFaXJ9KhsHEs7Cx4 for
	<xfs@oss.sgi.com>; Thu, 05 Mar 2015 08:48:15 -0800 (PST)
Received: from [192.168.81.12] (cpe-76-88-74-73.san.res.rr.com [76.88.74.73])
	by ceres.bofanez.org (Postfix) with ESMTPSA id 7743D8079
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 08:48:15 -0800 (PST)
Message-ID: <54F888CD.3070200@bofanez.org>
Date: Thu, 05 Mar 2015 08:48:13 -0800
From: peteman <peteman@bofanez.org>
MIME-Version: 1.0
Subject: debian xfsprogs package
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

the debian xfsprogs package places xfs_check in /usr/sbin. This causes 
problems when fscking the /usr partition....

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
