Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A559729E34
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 08:02:09 -0500 (CDT)
Received: from xmail.sgi.com (pv-excas1-dc21-nlb.corp.sgi.com [137.38.102.126])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9174630407F
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 06:02:06 -0700 (PDT)
Message-ID: <518A4CE1.5050108@sgi.com>
Date: Wed, 8 May 2013 08:02:25 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: 3.1.11 release
References: <20130430193734.216401872@sgi.com>
In-Reply-To: <20130430193734.216401872@sgi.com>
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

Hi Folks,

I would like to commit this patch today.  Will someone please review this!

I will update the dates for debian/changelog and doc/CHANGES and 
following will also be added to doc/CHANGES.

+	- Validate the extent count is at least within the positive
+	  range of a signed 32 bit integer before using it.

Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
