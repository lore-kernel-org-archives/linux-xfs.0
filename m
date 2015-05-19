Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A4DBC7F50
	for <xfs@oss.sgi.com>; Tue, 19 May 2015 09:53:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4E83DAC002
	for <xfs@oss.sgi.com>; Tue, 19 May 2015 07:53:12 -0700 (PDT)
Received: from fox.ncac.torun.pl (fox.ncac.torun.pl [158.75.101.70]) by
	cuda.sgi.com with ESMTP id OBscYFwHEqGiRh1H (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 19 May 2015 07:53:09 -0700 (PDT)
Received: from [158.75.101.16] (jb.ncac.torun.pl [158.75.101.16])
	(authenticated bits=0)
	by fox.ncac.torun.pl (8.14.8/jb.23.IX.2014) with ESMTP id
	t4JEr72W026631
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NOT)
	for <xfs@oss.sgi.com>; Tue, 19 May 2015 16:53:07 +0200
Message-ID: <555B4E53.8050908@ncac.torun.pl>
Date: Tue, 19 May 2015 16:53:07 +0200
From: Jerzy Borkowski <jubork@ncac.torun.pl>
MIME-Version: 1.0
Subject: inode64
References: <4D4BF051.9000608@ncac.torun.pl>
In-Reply-To: <4D4BF051.9000608@ncac.torun.pl>
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

Hi,

If an 800GB XFS filesystem is mounted with inode64 option,
is it guaranteed that all inodes in the filesystem are in
the range 0-0xFFFFFFFF ?
Kernel is 3.17.x

Thanks,

Jurek

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
