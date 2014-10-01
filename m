Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B8F4F7F5A
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 10:18:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A79ED8F8037
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 08:18:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YIQqBfjaAV0yQwHE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 08:18:16 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s91FIEGs031045
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Wed, 1 Oct 2014 11:18:15 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s91FIDJa026451
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 1 Oct 2014 11:18:14 -0400
Message-ID: <542C1B36.5080804@redhat.com>
Date: Wed, 01 Oct 2014 10:18:14 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH 0/2 RESEND] xfs: small bugfixes
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

These are 2 patches which were already sent for kernel
& userspace; they made it to userspace, but I don't see
them in for-next, so resending.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
