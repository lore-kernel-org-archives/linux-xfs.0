Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 777B97F3F
	for <xfs@oss.sgi.com>; Wed,  8 Jan 2014 05:43:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0234CAC001
	for <xfs@oss.sgi.com>; Wed,  8 Jan 2014 03:43:19 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CD93vUDTJ1ZQF2Gh for
	<xfs@oss.sgi.com>; Wed, 08 Jan 2014 03:43:19 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s08BhIEG018331
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 8 Jan 2014 06:43:18 -0500
Received: from orion.maiolino.org (ovpn-113-48.phx2.redhat.com [10.3.113.48])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with
	ESMTP id s08BhF4H030817
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 8 Jan 2014 06:43:17 -0500
Date: Wed, 8 Jan 2014 09:43:14 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 0/2] xfstests: UDF support improvements
Message-ID: <20140108114313.GA20531@orion.maiolino.org>
References: <1387839231-8558-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1387839231-8558-1-git-send-email-jack@suse.cz>
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
To: xfs@oss.sgi.com

Looks good to me

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


On Mon, Dec 23, 2013 at 11:53:49PM +0100, Jan Kara wrote:
> 
>   Hello,
> 
>   below are two patches which improve UDF support in xfstests.
> 
> 								Honza
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
