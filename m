Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2E93229DF8
	for <linux-xfs@oss.sgi.com>; Mon,  6 May 2013 04:40:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BB703AC006
	for <linux-xfs@oss.sgi.com>; Mon,  6 May 2013 02:40:27 -0700 (PDT)
Received: from mailgw1.uni-kl.de (mailgw1.uni-kl.de [131.246.120.220]) by
	cuda.sgi.com with ESMTP id MdDOVsvSlQuwDZqk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for
	<linux-xfs@oss.sgi.com>; Mon, 06 May 2013 02:40:26 -0700 (PDT)
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-9.4) with ESMTP id
	r469eObj023381
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-xfs@oss.sgi.com>; Mon, 6 May 2013 11:40:24 +0200
Received: from mail2.itwm.fhg.de ([131.246.191.79]:42122)
	by itwm2.itwm.fhg.de with esmtps (TLSv1:DES-CBC3-SHA:168)
	(/C=DE/ST=Rheinland-Pfalz/L=Kaiserslautern/O=Fraunhofer
	ITWM/OU=SLG/CN=mail2.itwm.fhg.de)(verified=1) (Exim 4.74 #1)
	id 1UZHuC-0002Pl-BL
	for linux-xfs@oss.sgi.com; Mon, 06 May 2013 11:40:24 +0200
Message-ID: <51877A88.6000009@itwm.fraunhofer.de>
Date: Mon, 06 May 2013 11:40:24 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
MIME-Version: 1.0
Subject: Re: 3.9.0: general protection fault
References: <kltu6o$33j$1@ger.gmane.org> <km7oop$28c$1@ger.gmane.org>
In-Reply-To: <km7oop$28c$1@ger.gmane.org>
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
Cc: linux-xfs@oss.sgi.com

On 05/06/2013 10:14 AM, Bernd Schubert wrote:
> And anpther protection fault, this time with 3.9.0. Always happens on
> one of the servers. Its ECC memory, so I don't suspect a faulty memory
> bank. Going to fsck now-


xfs_repair didn't find anything.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
