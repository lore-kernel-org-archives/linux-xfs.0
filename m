Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4F7AA29E0C
	for <xfs@oss.sgi.com>; Sun,  7 Apr 2013 22:42:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2C2A08F8035
	for <xfs@oss.sgi.com>; Sun,  7 Apr 2013 20:42:21 -0700 (PDT)
Received: from mail-pa0-f45.google.com (mail-pa0-f45.google.com
	[209.85.220.45]) by cuda.sgi.com with ESMTP id AK9zjIB9X7y6ghAM
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 07 Apr 2013 20:42:20 -0700 (PDT)
Received: by mail-pa0-f45.google.com with SMTP id kl13so3060598pab.4
	for <xfs@oss.sgi.com>; Sun, 07 Apr 2013 20:42:19 -0700 (PDT)
Date: Mon, 8 Apr 2013 11:59:13 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] xfstests: add _require_seek_data_hole to check seek
	data/hole
Message-ID: <20130408035913.GC32102@gmail.com>
References: <1364289252-7012-1-git-send-email-wenqing.lz@taobao.com>
	<515EE5A5.7070608@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <515EE5A5.7070608@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, xfs@oss.sgi.com

On Fri, Apr 05, 2013 at 09:54:29AM -0500, Rich Johnston wrote:
> Looks reasonable, will you please rework this for TOT changes?
> 
> tests 285 and 286 are now in the tests/generic directory and
> common.rc is now common/rc

Thanks for pointing it out.  I will rework this patch.

Regards,
                                                - Zheng

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
