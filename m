Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 45EF429E09
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 18:00:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C93B4AC005
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 16:00:34 -0700 (PDT)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id sIB6UaxD8Je03yDf (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 16:00:33 -0700 (PDT)
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Tue, 18 Jun 2013 19:00:33 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id B729C6E803A
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 19:00:26 -0400 (EDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r5IN002r335652 for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 19:00:00 -0400
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r5IN00tB020467
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 17:00:00 -0600
Received: from [9.41.106.170] (chandra-dt.austin.ibm.com [9.41.106.170])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	r5IMxxRc020439 for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 16:59:59 -0600
Subject: WANTED: xfstests results in different architectures
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Tue, 18 Jun 2013 17:59:59 -0500
Message-ID: <1371596399.22504.38.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: XFS mailing list <xfs@oss.sgi.com>

Hello All,

Couple of weeks backs we had a discussion in xfs meeting to collect
xfstests results. I volunteered to collect xfstests results from
different architectures and upload to XFS.org.

I can run and get the results for x86_64 and ppc64. If anyone has other
architectures that they can run the tests on and provide me the results,
I will filter them an upload to XFS.org.

Here is what I think would be of value to provide along with the results
(others, please feel free to add more to the list for the results to be
more useful)
    - Architecture of the system
    - Configuration - memory size and number of procs
    - Filesystem sizes
    - Commit ID of the kernel
    - which git tree (XFS git tree or Linus's)
    - xfsprogs version (or commit ID if from the git tree)

Thanks for your help in advance.

Regards,

Chandra


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
