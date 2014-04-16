Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 32DA429DFD
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 11:09:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1940E304077
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 09:09:44 -0700 (PDT)
Received: from mail.windriver.com (mail.windriver.com [147.11.1.11]) by
	cuda.sgi.com with ESMTP id mTMCp0YIhg77zK1C (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 09:09:33 -0700 (PDT)
Message-ID: <534EAB41.60901@windriver.com>
Date: Wed, 16 Apr 2014 12:09:37 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
MIME-Version: 1.0
Subject: new 64 bit math link fail in xfs in linux-next today
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
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, xfs@oss.sgi.com

Hi Dave,

Not sure if this has been reported yet, but this new failure showed
up in the xtensa link of today's linux-next builds.

http://kisskb.ellerman.id.au/kisskb/buildresult/10938384/

Paul.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
