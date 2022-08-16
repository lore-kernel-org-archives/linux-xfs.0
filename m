Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A73C25B0E
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Aug 2022 11:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235277AbiHPLGO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 07:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235326AbiHPLFe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 07:05:34 -0400
Received: from mailly.debian.org (mailly.debian.org [IPv6:2001:41b8:202:deb:6564:a62:52c3:4b72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB99F65A4
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 02:57:34 -0700 (PDT)
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:49956)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
        by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <ftpmaster@ftp-master.debian.org>)
        id 1oNtKG-009qFm-0J
        for linux-xfs@vger.kernel.org; Tue, 16 Aug 2022 09:57:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=vbnAJ6CgunWlyP45J3zdItRk/6wFYYIvMXaNZDRT4/c=; b=sbsTDQeUx8XKWKguY7kuhdDrXW
        1RiFW5eJ0NuB+6akqNcdDg5exORWuxcmjpvBDz7fnm8L3WcOvS5MZXzfClPLHbHT9J22K2ayB47Ln
        ZsutixHi+gEDSg/THUesQKWlXbJwy5k4ocQOFcBVf1X9wyVRvVEWcRzyxhh7GKbQHtYmsVCVAm8Ds
        JyaLV/nDBCJ13vfnrmfsltcEBOK10qO86A9gE9NTfrcAxvqrl0FokRF8Cps6fX13j5PAS7995oIpn
        l5UMMNOmJZ/GkvhpqHoMWbGxr1K+/4Q1cDnpJH96Pku0U+WnAUlpEUseNQH0vlBplISLNMjqIb3dE
        NeTT9uwg==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.94.2)
        (envelope-from <ftpmaster@ftp-master.debian.org>)
        id 1oNtKE-005oor-OJ
        for linux-xfs@vger.kernel.org; Tue, 16 Aug 2022 09:57:30 +0000
To:     linux-xfs@vger.kernel.org
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_5.19.0-1_source.changes
Date:   Tue, 16 Aug 2022 09:57:30 +0000
X-Debian: DAK
X-DAK:  DAK
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1oNtKE-005oor-OJ@usper.debian.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfsprogs_5.19.0-1_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_5.19.0-1.dsc
  xfsprogs_5.19.0.orig.tar.xz
  xfsprogs_5.19.0-1.debian.tar.xz
  xfsprogs_5.19.0-1_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
