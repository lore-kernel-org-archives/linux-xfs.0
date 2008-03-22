Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 22 Mar 2008 07:11:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2MEAvxu027482
	for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 07:11:00 -0700
Received: from smtp-out003.kontent.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CCE76125BB8B
	for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 07:11:30 -0700 (PDT)
Received: from smtp-out003.kontent.com (smtp-out003.kontent.com [81.88.40.217]) by cuda.sgi.com with ESMTP id NCP0Eq2SEEGE3EsR for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 07:11:30 -0700 (PDT)
Message-ID: <47E5136E.3060807@theendofthetunnel.de>
Date: Sat, 22 Mar 2008 15:10:54 +0100
From: Hannes Dorbath <light@theendofthetunnel.de>
MIME-Version: 1.0
Subject: Re: Update of XFSPROG XFSDUMP on linux kernel 2.4.22
References: <1205842046.47dfb07ede86d@hermesadm.chb.fr>
In-Reply-To: <1205842046.47dfb07ede86d@hermesadm.chb.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Xavier Poirier <xpoirier@ch-bourg01.fr>
Cc: xfs@oss.sgi.com

Xavier Poirier wrote:
> - Linux Mandrake 9.2 kernel 2.4.22
> - XFSDUMP 2.2.13
> - XFSDUMP 2.5.4  (installed by RPM) 

I doubt XFS on 2.4.x was ever meant for production use. This is 2008, 
grab a nice 2.6.23-r17 and latest xfsprogs from 
ftp://oss.sgi.com/projects/xfs/cmd_tars/ ;)


-- 
Best regards,
Hannes Dorbath
